variable "resource_group_name" {
  description = "Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created."
  type        = string
}

variable "automatic_channel_upgrade" {
  description = "The upgrade channel for this Kubernetes Cluster. Possible values are `patch`, `rapid`, `node-image` and `stable`."
  type        = string
  default     = null
}

variable "azure_policy_enabled" {
  description = "Is the Azure Policy for Kubernetes Add On enabled?"
  type        = bool
  default     = true
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster. Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use for the cluster. Default is set to null which is the latest version in Azure. https://docs.microsoft.com/en-us/azure/aks/supported-kubernetes-versions?tabs=azure-cli#alias-minor-version"
  type        = string
  default     = null
}

variable "http_application_routing_enabled" {
  description = "Is HTTP Application Routing Enabled?"
  type        = bool
  default     = false
}

variable "oidc_issuer_enabled" {
  description = "Enable or Disable the OIDC issuer URL. https://learn.microsoft.com/en-gb/azure/aks/use-oidc-issuer"
  type        = bool
  default     = null
}

variable "private_cluster_enabled" {
  description = "Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located"
  type        = bool
  default     = false
}

variable "private_dns_zone_id" {
  description = "ID of Private DNS Zone which should be delegated to this Cluster."
  type        = string
  default     = null
}

variable "role_based_access_control_enabled" {
  description = "Whether Role Based Access Control for the Kubernetes Cluster should be enabled. Changing this forces a new resource to be created."
  type        = bool
  default     = true
}

variable "sku_tier" {
  description = <<EOF
    The SKU Tier that should be used for this Kubernetes Cluster. Possible values are `Free` and `Standard` (which includes the Uptime SLA). Defaults to `Free`.
    Note: Some disruptives changes happened with the Sku Values. Initially, Paid was a supported value but it was version 3.51.0 to be superseeded by Standard, which was introduced in version 3.46.0. 
  EOF
  default     = "Free"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(any)
}

variable "user_identity_name" {
  description = "The name of the user managed identity that will be created for the Cluster."
  type        = string
  default     = null
}


variable "virtual_network_id" {
  description = "The Virtual Network ID to assign RBAC. Required for a private cluster."
  type        = string
  default     = null
}

variable "workload_identity_enabled" {
  description = "Specifies whether Azure AD Workload Identity should be enabled for the Cluster."
  type        = bool
  default     = null
}

#####################################################################
######################## behaviour variables ########################
#####################################################################

variable "acr_ids" {
  description = "List of ACR IDs to allow to Pull images using the SP/Managed Indentity."
  type        = map(string)
  default     = {}
}

variable "diagnostic_logs" {
  description = <<EOF
    Diagnostic logs settings for the Azure Kubernetes cluster resource. It accepts an object with the following attributes:
    - log_analytics_workspace_id: ID of the log analytics workspace (required).
    - log_category_groups: Log categories to enable (optional, default: ["allLogs", "audit"]).
    - metrics: Metrics to enable (optional, default: ["AllMetrics"]).
  EOF
  type = object({
    log_analytics_workspace_id = string
    log_category_groups        = optional(list(string), ["allLogs", "audit"])
    metrics                    = optional(list(string), ["AllMetrics"])
  })
  default = null
}

#####################################################################
################ api_server_access_profile variables ################
#####################################################################

variable "authorized_ip_ranges" {
  description = "Set of authorized IP ranges to allow access to API server, e.g. [\"198.51.100.0/24\"]."
  type        = list(string)
  default     = null
}

#####################################################################
#################### default_node_pool variables ####################
#####################################################################

variable "default_node_pool_name" {
  description = "The name which should be used for the default Kubernetes Node Pool. Changing this forces a new resource to be created."
  type        = string
  default     = "system"
}

variable "enable_auto_scaling" {
  description = "Should the Kubernetes Auto Scaler be enabled for this Node Pool?"
  type        = bool
  default     = true
}

variable "enable_node_public_ip" {
  description = "Should nodes in this Node Pool have a Public IP Address? Changing this forces a new resource to be created."
  type        = bool
  default     = null
}

variable "max_count" {
  description = "The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
  type        = number
  default     = null
}

variable "max_pods" {
  description = "The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
  default     = null #30, max 250
}

variable "min_count" {
  description = "The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
  type        = number
  default     = null
}

variable "default_pool_node_count" {
  description = "The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 and between min_count and max_count."
  type        = number
  default     = null
}

variable "only_critical_addons_enabled" {
  description = "Enabling this option will taint default node pool with CriticalAddonsOnly=true:NoSchedule taint. Changing this forces a new resource to be created."
  default     = null
  type        = bool
}

variable "vm_size" {
  description = "The size of the Virtual Machine, such as Standard_D2a_v4. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard_D2S_v5"
}

variable "vnet_subnet_id" {
  description = "The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "zones" {
  description = "Specifies a list of Availability Zones in which this Kubernetes Cluster should be located. Changing this forces a new Kubernetes Cluster to be created. Like: ['1', '2', '3']"
  type        = list(string)
  default     = null
}

###################################################################
#################### network profile variables ####################
###################################################################

variable "dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created."
  type        = string
  default     = null # equals to "10.0.0.10"
}

variable "docker_bridge_cidr" {
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created."
  type        = string
  default     = null # equals to "172.17.0.1/16"
}

variable "load_balancer_sku" {
  description = "Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Possible values are `basic` and `standard`."
  type        = string
  default     = "standard"
}


variable "network_plugin" {
  description = "Network plugin to use for networking. Currently supported values are `azure`, `kubenet` and `none`. Changing this forces a new resource to be created."
  type        = string
  default     = "azure"
}

variable "network_policy" {
  default     = "azure"
  type        = string
  description = <<EOF
    Sets up network policy to be used with Azure CNI. [Network policy](https://docs.microsoft.com/azure/aks/use-network-policies) allows us to control the traffic flow between pods. Currently supported values are `calico` and `azure`. Changing this forces a new resource to be created. 
    NOTE: When network_policy is set to `azure`, the network_plugin field can only be set to `azure`.
  EOF
}

variable "outbound_ip_address_ids" {
  description = "The ID of the Public IP Addresses which should be used for outbound communication for the cluster load balancer."
  type        = list(string)
  default     = []
}

variable "outbound_type" {
  description = "The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are `loadBalancer`, `managedNATGateway`, `userAssignedNATGateway` and `userDefinedRouting`."
  type        = string
  default     = "loadBalancer"
}

variable "pod_cidr" {
  description = "The CIDR to use for pod IP addresses. This field can only be set when `network_plugin` is set to `kubenet`. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "service_cidr" {
  description = "The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
  type        = string
  default     = null # equals to "10.0.0.0/16"
}

####################################################################
#### azure_active_directory_role_based_access_control variables ####
####################################################################

variable "azure_ad_enabled" {
  description = "Enables Azure AD authentication to the Kubernetes cluster. Defaults to false."
  type        = bool
  default     = false
}

variable "azure_ad_rbac_enabled" {
  description = "Enables Azure AD RBAC on the Kubernetes cluster, defaults to `false` and requires `azure_ad_enabled` to be set to `true`."
  type        = bool
  default     = false
}

variable "azure_ad_managed" {
  description = "Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration. Defaults to false."
  type        = bool
  default     = false
}

variable "azure_ad_tenant_id" {
  description = "The Tenant ID used for Azure Active Directory Application. If this isn't specified the Tenant ID of the current Subscription is used."
  type        = string
  default     = null
}

variable "azure_ad_admin_group_object_ids" {
  description = "A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster."
  type        = list(string)
  default     = [""]
}

variable "azure_ad_client_app_id" {
  description = "The Client ID of an Azure Active Directory Application."
  type        = string
  default     = null
}

variable "azure_ad_server_app_id" {
  description = "The Server ID of an Azure Active Directory Application."
  type        = string
  default     = null
}

variable "azure_ad_server_app_secret" {
  description = "The Server Secret of an Azure Active Directory Application."
  type        = string
  default     = null
}

###################################################################
################## auto_scaler_profile variables ##################
###################################################################

variable "balance_similar_node_groups" {
  description = "Detect similar node groups and balance the number of nodes between them. Defaults to false."
  default     = null
}

variable "empty_bulk_delete_max" {
  description = "Maximum number of empty nodes that can be deleted at the same time. Defaults to 10."
  default     = null
  type        = number
}

variable "expander" {
  description = "Expander to use. Possible values are least-waste, priority, most-pods and random. Defaults to random."
  default     = null
}

variable "max_graceful_termination_sec" {
  description = "Maximum number of seconds the cluster autoscaler waits for pod termination when trying to scale down a node. Defaults to 600."
  default     = null
}

variable "max_node_provisioning_time" {
  description = "Maximum time the autoscaler waits for a node to be provisioned. Defaults to 15m."
  default     = null
}

variable "max_unready_nodes" {
  description = "Maximum Number of allowed unready nodes. Defaults to 3."
  default     = null
  type        = string
}

variable "max_unready_percentage" {
  description = "Maximum percentage of unready nodes the cluster autoscaler will stop if the percentage is exceeded. Defaults to 45."
  default     = null
  type        = string
}

variable "new_pod_scale_up_delay" {
  description = "For scenarios like burst/batch scale where you don't want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they're a certain age. Defaults to 10s."
  default     = null
  type        = string
}

variable "scale_down_delay_after_add" {
  description = "How long after the scale up of AKS nodes the scale down evaluation resumes. Defaults to 10m."
  default     = null
  type        = string
}

variable "scale_down_delay_after_delete" {
  description = "How long after node deletion that scale down evaluation resumes. Defaults to the value used for scan_interval."
  default     = null
  type        = string
}

variable "scale_down_delay_after_failure" {
  description = "How long after scale down failure that scale down evaluation resumes. Defaults to 3m."
  default     = null
  type        = string
}

variable "scale_down_unneeded" {
  description = "How long a node should be unneeded before it is eligible for scale down. Defaults to 10m."
  default     = null
  type        = string
}

variable "scale_down_unready" {
  description = "How long an unready node should be unneeded before it is eligible for scale down. Defaults to 20m."
  default     = null
  type        = string
}

variable "scale_down_utilization_threshold" {
  description = "Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down. Defaults to 0.5."
  default     = null
  type        = string
}

variable "scan_interval" {
  description = "How often the AKS Cluster should be re-evaluated for scale up/down. Defaults to 10s."
  default     = null
  type        = string
}

variable "skip_nodes_with_local_storage" {
  description = "If true cluster autoscaler will never delete nodes with pods with local storage, for example, EmptyDir or HostPath. Defaults to true."
  default     = null
  type        = bool
}

variable "skip_nodes_with_system_pods" {
  description = "If true cluster autoscaler will never delete nodes with pods from kube-system (except for DaemonSet or mirror pods). Defaults to true."
  default     = null
  type        = bool
}
