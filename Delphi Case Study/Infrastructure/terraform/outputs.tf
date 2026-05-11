output "resource_group_id" {
  value       = azurerm_resource_group.rg.id
  description = "Resource Group ID"
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Resource Group name"
}

# Networking Outputs
output "vnet_id" {
  value       = module.networking.vnet_id
  description = "Virtual Network ID"
}

output "aks_subnet_id" {
  value       = module.networking.aks_subnet_id
  description = "AKS Subnet ID"
}

output "app_service_subnet_id" {
  value       = module.networking.app_service_subnet_id
  description = "App Service Subnet ID"
}

# AKS Outputs
output "aks_cluster_id" {
  value       = module.aks.aks_cluster_id
  description = "AKS Cluster ID"
}

output "aks_cluster_name" {
  value       = module.aks.aks_cluster_name
  description = "AKS Cluster name"
}

output "aks_fqdn" {
  value       = module.aks.aks_fqdn
  description = "AKS Cluster FQDN"
}

output "oidc_issuer_url" {
  value       = module.aks.oidc_issuer_url
  description = "OIDC issuer URL for workload identity"
}

output "kube_config_raw" {
  value       = module.aks.kube_config_raw
  sensitive   = true
  description = "Raw kubeconfig for kubectl access"
}

# ACR Outputs
output "acr_id" {
  value       = module.acr.acr_id
  description = "ACR ID"
}

output "acr_name" {
  value       = module.acr.acr_name
  description = "ACR name"
}

output "acr_login_server" {
  value       = module.acr.acr_login_server
  description = "ACR login server"
}

# Key Vault Outputs
output "key_vault_id" {
  value       = module.keyvault.key_vault_id
  description = "Key Vault ID"
}

output "key_vault_name" {
  value       = module.keyvault.key_vault_name
  description = "Key Vault name"
}

output "key_vault_uri" {
  value       = module.keyvault.key_vault_uri
  description = "Key Vault URI"
}

# App Service Outputs
output "app_service_id" {
  value       = module.app_service.app_service_id
  description = "App Service ID"
}

output "app_service_name" {
  value       = module.app_service.app_service_name
  description = "App Service name"
}

output "app_service_default_hostname" {
  value       = module.app_service.app_service_default_hostname
  description = "App Service default hostname"
}
/*
output "app_insights_instrumentation_key" {
  value       = module.app_service.app_insights_instrumentation_key
  sensitive   = true
  description = "Application Insights instrumentation key"
}
*/

output "deployment_summary" {
  value = {
    resource_group    = azurerm_resource_group.rg.name
    environment       = var.environment
    location          = var.location
    aks_cluster_name  = module.aks.aks_cluster_name
    acr_name          = module.acr.acr_name
    key_vault_name    = module.keyvault.key_vault_name
    app_service_name  = module.app_service.app_service_name
    app_service_url   = "https://${module.app_service.app_service_default_hostname}"
  }
  description = "Summary of deployed resources"
}
