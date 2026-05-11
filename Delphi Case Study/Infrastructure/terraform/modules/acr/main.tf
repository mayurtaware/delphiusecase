terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = replace("${var.environment}${var.registry_name}", "-", "")
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  admin_enabled = var.admin_enabled

  public_network_access_enabled = false  

  # Retention policy for untagged manifests
  retention_policy {
    enabled = true
    days    = var.retention_policy_days
  }

  # Network rules for security
  network_rule_bypass_option = "AzureServices"

  identity {
    type = "SystemAssigned"  
  }


  tags = var.tags
}

# Private Endpoint for ACR
resource "azurerm_private_endpoint" "acr_pe" {
  name                = "${var.environment}-acr-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.vnet_subnet_id

  private_service_connection {
    name                           = "${var.environment}-acr-psc"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# Private DNS Zone for ACR
resource "azurerm_private_dns_zone" "acr_dns" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "acr_dns_link" {
  name                  = "${var.environment}-acr-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr_dns.name
  virtual_network_id    = var.vnet_id

  tags = var.tags
}

# DNS A record for private endpoint
resource "azurerm_private_dns_a_record" "acr_dns_record" {
  name                = azurerm_container_registry.acr.name
  zone_name           = azurerm_private_dns_zone.acr_dns.name
  resource_group_name = var.resource_group_name
  ttl                 = 10
  records             = [azurerm_private_endpoint.acr_pe.private_service_connection[0].private_ip_address]

  tags = var.tags
}

