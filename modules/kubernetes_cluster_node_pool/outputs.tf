output "id" {
  description = "The ID of the Kubernetes Cluster Node Pool."
  value       = azurerm_kubernetes_cluster_node_pool.cluster.id
}