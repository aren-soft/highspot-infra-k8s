terraform {
  required_version = ">=1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.87.0"
    }
  }
}

resource "azurerm_user_assigned_identity" "cluster_identity" {
  resource_group_name = var.resource_group_name
  name                = var.user_identity_name
  location            = var.location
}

locals {
  cluster_identity     = azurerm_user_assigned_identity.cluster_identity
  cluster_identity_ids = [local.cluster_identity.id]
}

# Note: For this rbac, the SPN needs to have 'User Access Administrator' role in the Private DNS Zone.
resource "azurerm_role_assignment" "rbac_dnszone" {
  count                = var.private_cluster_enabled ? 1 : 0
  scope                = var.private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = local.cluster_identity.id
}

# BYO Subnet, Route Table, SLB and NSG permissions
resource "azurerm_role_assignment" "rbac_network" {
  count                = var.private_cluster_enabled ? 1 : 0
  scope                = var.virtual_network_id
  role_definition_name = "Network Contributor"
  principal_id         = local.cluster_identity.id
}

# Allow control-plane-identity to use kubelet-identity
resource "azurerm_role_assignment" "rbac_identity" {
  principal_id         = local.cluster_identity.principal_id
  scope                = local.cluster_identity.id
  role_definition_name = "Managed Identity Operator"
}

# Wait for role assignment to propagate
resource "time_sleep" "wait_rbac_propagation" {
  depends_on = [
    azurerm_role_assignment.rbac_identity,
    azurerm_role_assignment.rbac_network,
    azurerm_role_assignment.rbac_dnszone
  ]
  create_duration = "120s"
}

locals {
  wait_rbac_propagation = time_sleep.wait_rbac_propagation
}

resource "azurerm_kubernetes_cluster" "k8cluster" {
  resource_group_name               = var.resource_group_name
  name                              = var.name
  location                          = var.location
  automatic_channel_upgrade         = var.automatic_channel_upgrade
  azure_policy_enabled              = var.azure_policy_enabled
  dns_prefix                        = var.dns_prefix
  kubernetes_version                = var.kubernetes_version
  http_application_routing_enabled  = var.http_application_routing_enabled
  oidc_issuer_enabled               = var.workload_identity_enabled ? true : var.oidc_issuer_enabled
  private_cluster_enabled           = var.private_cluster_enabled
  private_dns_zone_id               = var.private_dns_zone_id
  role_based_access_control_enabled = var.role_based_access_control_enabled
  sku_tier                          = var.sku_tier
  tags                              = var.tags
  workload_identity_enabled         = var.workload_identity_enabled

  api_server_access_profile {
    authorized_ip_ranges = var.authorized_ip_ranges
  }

  auto_scaler_profile {
    balance_similar_node_groups      = var.balance_similar_node_groups
    empty_bulk_delete_max            = var.empty_bulk_delete_max #reffered to as max-empty-bulk-delete in MSFT docs
    expander                         = var.expander
    max_graceful_termination_sec     = var.max_graceful_termination_sec
    max_node_provisioning_time       = var.max_node_provisioning_time
    max_unready_nodes                = var.max_unready_nodes      #referred to as ok-total-unready-count in MSFT docs
    max_unready_percentage           = var.max_unready_percentage #referred to as max-total-unready-percentage in MSFT docs
    new_pod_scale_up_delay           = var.new_pod_scale_up_delay
    scale_down_delay_after_add       = var.scale_down_delay_after_add
    scale_down_delay_after_delete    = var.scale_down_delay_after_delete
    scale_down_delay_after_failure   = var.scale_down_delay_after_failure
    scale_down_unneeded              = var.scale_down_unneeded #referred to as scale-down-unneeded-time in MSFT docs
    scale_down_unready               = var.scale_down_unready  #reffered to as scale-down-unready-time in MSFT docs
    scale_down_utilization_threshold = var.scale_down_utilization_threshold
    scan_interval                    = var.scan_interval
    skip_nodes_with_local_storage    = var.skip_nodes_with_local_storage
    skip_nodes_with_system_pods      = var.skip_nodes_with_system_pods
  }

  default_node_pool {
    name                         = var.default_node_pool_name
    enable_auto_scaling          = var.enable_auto_scaling
    enable_node_public_ip        = var.enable_node_public_ip
    max_count                    = var.max_count
    max_pods                     = var.max_pods
    min_count                    = var.min_count
    node_count                   = var.default_pool_node_count
    only_critical_addons_enabled = var.only_critical_addons_enabled
    orchestrator_version         = var.kubernetes_version
    vm_size                      = var.vm_size
    vnet_subnet_id               = var.vnet_subnet_id
    zones                        = var.zones
  }

  identity {
    type         = "UserAssigned"
    identity_ids = local.cluster_identity_ids
  }

  kubelet_identity {
    client_id                 = local.cluster_identity.client_id
    object_id                 = local.cluster_identity.principal_id
    user_assigned_identity_id = local.cluster_identity.id
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.azure_ad_enabled ? [1] : []
    content {
      managed                = var.azure_ad_managed
      tenant_id              = var.azure_ad_tenant_id
      admin_group_object_ids = var.azure_ad_admin_group_object_ids
      azure_rbac_enabled     = var.azure_ad_rbac_enabled
      client_app_id          = var.azure_ad_client_app_id
      server_app_id          = var.azure_ad_server_app_id
      server_app_secret      = var.azure_ad_server_app_secret
    }
  }

  dynamic "network_profile" {
    for_each = var.network_policy == null ? [] : [var.network_policy]

    content {
      docker_bridge_cidr = var.docker_bridge_cidr
      dns_service_ip     = var.dns_service_ip
      load_balancer_sku  = var.load_balancer_sku
      network_plugin     = var.network_plugin
      network_policy     = var.network_policy
      outbound_type      = var.outbound_type
      pod_cidr           = var.pod_cidr
      service_cidr       = var.service_cidr
      load_balancer_profile {
        outbound_ip_address_ids = var.outbound_ip_address_ids
      }
    }
  }

  depends_on = [
    local.wait_rbac_propagation
  ]
}

resource "azurerm_role_assignment" "attach_acrs" {
  for_each             = var.acr_ids
  principal_id         = azurerm_kubernetes_cluster.k8cluster.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = each.value
}

resource "azurerm_monitor_diagnostic_setting" "dlogs" {
  count                          = var.diagnostic_logs == null ? 0 : 1
  name                           = "diag-${azurerm_kubernetes_cluster.k8cluster.name}"
  log_analytics_workspace_id     = var.diagnostic_logs.log_analytics_workspace_id
  target_resource_id             = azurerm_kubernetes_cluster.k8cluster.id
  log_analytics_destination_type = "AzureDiagnostics"

  dynamic "enabled_log" {
    for_each = var.diagnostic_logs.log_category_groups
    content {
      category_group = enabled_log.value
    }
  }
  dynamic "metric" {
    for_each = var.diagnostic_logs.metrics
    content {
      category = metric.value
    }
  }
}
