output "acr_id" {
  value       = azurerm_container_registry.acr.id
  description = "Container Registry ID"
}

output "acr_name" {
  value       = azurerm_container_registry.acr.name
  description = "Container Registry name"
}

output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "Container Registry login server URL"
}

output "acr_admin_username" {
  value       = var.admin_enabled ? azurerm_container_registry.acr.admin_username : null
  description = "Container Registry admin username"
  sensitive   = true
}

output "acr_admin_password" {
  value       = var.admin_enabled ? azurerm_container_registry.acr.admin_password : null
  description = "Container Registry admin password"
  sensitive   = true
}

output "acr_token_name" {
  value       = azurerm_container_registry_token.acr_token.name
  description = "ACR token name for authentication"
}

output "acr_token_password1" {
  value       = azurerm_container_registry_token_password.acr_token_password.password1[0].value
  description = "ACR token password"
  sensitive   = true
}

output "private_endpoint_id" {
  value       = azurerm_private_endpoint.acr_pe.id
  description = "Private endpoint ID"
}


output "acr_principal_id" {
  description = "Principal ID of the ACR system-assigned identity"
  value       = azurerm_container_registry.acr.identity[0].principal_id
}
