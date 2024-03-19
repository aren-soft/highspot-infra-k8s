output "client_certificate" {
  value     = azurerm_kubernetes_cluster.k8cluster.kube_config.0.client_certificate
  sensitive = true
}

output "id" {
  value = azurerm_kubernetes_cluster.k8cluster.id
}

output "fqdn" {
  value = azurerm_kubernetes_cluster.k8cluster.fqdn
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.k8cluster.kube_config
  sensitive = true
}

output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.k8cluster.kube_config_raw
  sensitive = true
}

output "kubelet_identity" {
  value = azurerm_kubernetes_cluster.k8cluster.kubelet_identity[0]
}

output "kubelet_identity_name" {
  value = "${azurerm_kubernetes_cluster.k8cluster.name}-agentpool"
}

output "name" {
  value = azurerm_kubernetes_cluster.k8cluster.name
}

output "node_resource_group" {
  description = "The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster."
  value       = azurerm_kubernetes_cluster.k8cluster.node_resource_group
}

output "node_resource_group_id" {
  description = "The ID of the Resource Group containing the resources for this Managed Kubernetes Cluster."
  value       = azurerm_kubernetes_cluster.k8cluster.node_resource_group_id
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL that is associated with the cluster."
  value       = azurerm_kubernetes_cluster.k8cluster.oidc_issuer_url
}

output "principal_id" {
  description = "The Principal ID for the Service Principal associated with the Managed Service Identity of this kubernetes cluster."
  value       = local.cluster_identity.principal_id
}

output "private_fqdn" {
  value = azurerm_kubernetes_cluster.k8cluster.private_fqdn
}

output "resource_group_name" {
  value = azurerm_kubernetes_cluster.k8cluster.resource_group_name
}

output "version" {
  value = azurerm_kubernetes_cluster.k8cluster.kubernetes_version
}
