output "kube_config" {
  value       = azurerm_kubernetes_cluster.aks.kube_config
  sensitive   = true
  description = "Kube config for cluster access"
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "Raw Kube config"
}

output "host" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].host
  sensitive   = true
  description = "Kubernetes API server address"
}

output "client_certificate" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive   = true
  description = "Client certificate for cluster access"
}

output "client_key" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
  sensitive   = true
  description = "Client key for cluster access"
}

output "cluster_ca_certificate" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
  sensitive   = true
  description = "Cluster CA certificate"
}

output "aks_cluster_id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "AKS Cluster resource ID"
}

output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "AKS Cluster name"
}

output "aks_fqdn" {
  value       = azurerm_kubernetes_cluster.aks.fqdn
  description = "AKS Cluster FQDN"
}

output "kubelet_identity" {
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  description = "Kubelet identity object ID"
}

output "oidc_issuer_url" {
  value       = var.enable_workload_identity ? azurerm_kubernetes_cluster.aks.oidc_issuer_url : null
  description = "OIDC issuer URL for workload identity"
}
