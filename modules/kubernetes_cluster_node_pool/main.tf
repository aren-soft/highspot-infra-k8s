resource "azurerm_kubernetes_cluster_node_pool" "cluster" {
  kubernetes_cluster_id = var.kubernetes_cluster_id
  name                  = var.name
  enable_auto_scaling   = var.enable_auto_scaling
  max_pods              = var.max_pods
  min_count             = var.min_count
  max_count             = var.max_count
  mode                  = var.mode
  node_count            = var.node_count
  node_labels           = var.node_labels
  os_disk_size_gb       = var.os_disk_size_gb
  tags                  = var.tags
  vm_size               = var.vm_size
  vnet_subnet_id        = var.vnet_subnet_id
  zones                 = var.zones
}
