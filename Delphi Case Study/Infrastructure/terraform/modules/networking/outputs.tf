output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "aks_subnet_id" {
  description = "The ID of the AKS subnet"
  value       = azurerm_subnet.aks_subnet.id
}

output "aks_subnet_name" {
  description = "The name of the AKS subnet"
  value       = azurerm_subnet.aks_subnet.name
}

output "app_service_subnet_id" {
  description = "The ID of the App Service subnet"
  value       = azurerm_subnet.app_service_subnet.id
}

output "app_service_subnet_name" {
  description = "The name of the App Service subnet"
  value       = azurerm_subnet.app_service_subnet.name
}

output "private_endpoint_subnet_id" {
  description = "The ID of the Private Endpoint subnet"
  value       = azurerm_subnet.private_endpoint_subnet.id
}

output "private_endpoint_subnet_name" {
  description = "The name of the Private Endpoint subnet"
  value       = azurerm_subnet.private_endpoint_subnet.name
}
