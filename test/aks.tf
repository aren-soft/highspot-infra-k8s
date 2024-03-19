locals {
  node_labels = {
    business_unit = local.product_area,
  }
  vm_size_user1_pool  = "Standard_D4_v4"
  vm_size_system_pool = "Standard_D2_v4"
}

module "kubernetes_clusters" {
  for_each                  = local.names
  source                    = "../modules/k8s_cluster/"
  resource_group_name       = lookup(local.main_resource_groups, each.key).name
  name                      = each.value.cluster.kubernetes_cluster[0]
  location                  = each.key
  dns_prefix                = "poc-k8s"
  kubernetes_version        = "1.27.7"
  oidc_issuer_enabled       = true
  private_cluster_enabled   = false
  sku_tier                  = "Standard"
  tags                      = local.tags
  user_identity_name        = each.value.cluster.managed_identity[0]
  workload_identity_enabled = true
  acr_ids = {
    (local.registry.name) = local.registry.id
  }
  # default_node_pool variables
  default_node_pool_name = "system"
  enable_auto_scaling    = true
  max_count              = 3
  max_pods               = 110
  min_count              = 1
  vm_size                = local.vm_size_system_pool
  vnet_subnet_id         = local.subnet_system[each.key].id
  # network profile variables
  network_plugin    = "azure"
  network_policy    = "azure"
  load_balancer_sku = "standard"
  outbound_type     = "loadBalancer"
}

module "kubernetes_runner_pools" {
  for_each              = module.kubernetes_clusters
  source                = "../modules/kubernetes_cluster_node_pool"
  kubernetes_cluster_id = each.value.id
  name                  = "buildauto0"
  enable_auto_scaling   = true
  max_count             = 10
  max_pods              = 110
  min_count             = 3
  os_disk_size_gb       = 300
  mode                  = "User"
  node_labels           = local.node_labels
  tags                  = local.tags
  vm_size               = local.vm_size_user1_pool
  vnet_subnet_id        = local.subnet_user1[each.key].id
}

# Roles to configure Load Balancer IPs
resource "azurerm_role_assignment" "rbac_network_aks_rg" {
  for_each             = module.kubernetes_clusters
  scope                = local.main_resource_groups[each.key].id
  role_definition_name = "Network Contributor"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "rbac_network_node_rg" {
  for_each             = module.kubernetes_clusters
  scope                = each.value.node_resource_group_id
  role_definition_name = "Network Contributor"
  principal_id         = each.value.principal_id
}

data "azurerm_kubernetes_cluster" "kc" {
  resource_group_name = local.rg.name
  name                = local.aks.name
  depends_on          = [local.aks]
}

locals {
  aks = module.kubernetes_clusters[local.clusterRegion]
  rg  = local.main_resource_groups[local.clusterRegion]
}
