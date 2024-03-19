# Required
variable "name" {
  description = <<EOF
    The name of the Node Pool which should be created within the Kubernetes Cluster. Changing this forces a new resource to be created. 
    NOTE: The name may only contain lowercase alphanumeric characters and must begin with a lowercase letter. The lenght is limited to 6 for Windows and 12 for linux 
    EOF
  type        = string
}

variable "kubernetes_cluster_id" {
  description = "The ID of the Kubernetes Cluster where this Node Pool should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "vm_size" {
  description = "The SKU which should be used for the Virtual Machines used in this Node Pool. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard_D2a_v4"
}

# Optional
variable "enable_auto_scaling" {
  description = "Whether to enable auto-scaler."
  type        = bool
  default     = true
}

variable "max_count" {
  description = "The maximum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be greater than or equal to min_count."
  type        = number
  default     = 3
}

variable "max_pods" {
  description = "The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
  default     = 32
}

variable "min_count" {
  description = "The minimum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be less than or equal to max_count."
  type        = number
  default     = 1
}

variable "mode" {
  description = "Should this Node Pool be used for System or User resources? Possible values are `System` and `User`."
  type        = string
  default     = "User"
}

variable "node_count" {
  description = "The initial number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 (inclusive) for user pools and between 1 and 1000 (inclusive) for system pools and must be a value in the range min_count - max_count."
  type        = number
  default     = null
}

variable "node_labels" {
  description = "A map of Kubernetes labels which should be applied to nodes in this Node Pool."
  type        = map(string)
  default     = null
}

variable "os_disk_size_gb" {
  description = "The Agent Operating System disk size in GB. Changing this forces a new resource to be created."
  default     = null
  type        = number
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "vnet_subnet_id" {
  description = "The ID of the Subnet where this Node Pool should exist. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "zones" {
  description = "Specifies a list of Availability Zones in which this Kubernetes Cluster Node Pool should be located. Changing this forces a new Kubernetes Cluster Node Pool to be created. Like: ['1', '2', '3']"
  type        = list(string)
  default     = null
}
