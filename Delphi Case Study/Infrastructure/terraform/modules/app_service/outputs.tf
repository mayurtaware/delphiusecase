output "app_service_id" {
  value       = azurerm_linux_web_app.app_service.id
  description = "App Service resource ID"
}

output "app_service_name" {
  value       = azurerm_linux_web_app.app_service.name
  description = "App Service name"
}

output "app_service_default_hostname" {
  value       = azurerm_linux_web_app.app_service.default_hostname
  description = "App Service default hostname"
}

output "app_service_plan_id" {
  value       = azurerm_service_plan.app_service_plan.id
  description = "App Service Plan ID"
}

/*
output "app_insights_instrumentation_key" {
  value       = azurerm_application_insights.app_insights.instrumentation_key
  description = "Application Insights instrumentation key"
  sensitive   = true
}


output "app_insights_connection_string" {
  value       = azurerm_application_insights.app_insights.connection_string
  description = "Application Insights connection string"
  sensitive   = true
}
*/

output "storage_account_id" {
  value       = azurerm_storage_account.app_storage.id
  description = "Storage account ID for backups"
}

output "app_service_identity_principal_id" {
  value       = azurerm_linux_web_app.app_service.identity[0].principal_id
  description = "App Service managed identity principal ID"
}

output "private_endpoint_id" {
  value       = azurerm_private_endpoint.app_service_pe.id
  description = "Private endpoint ID"
}
