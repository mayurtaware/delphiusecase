terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Get current user context
data "azurerm_client_config" "current" {}

# Azure Key Vault with enhanced security
resource "azurerm_key_vault" "kv" {
  name                            = replace("${var.environment}-${var.key_vault_name}", "-", "")
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku_name                        = var.sku_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization       = var.enable_rbac_authorization
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  soft_delete_retention_days       = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  
  # Network ACLs configuration
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "kv_pe" {
  name                = "${var.environment}-kv-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.vnet_subnet_id

  private_service_connection {
    name                           = "${var.environment}-kv-psc"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# Private DNS Zone for Key Vault
resource "azurerm_private_dns_zone" "kv_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "kv_dns_link" {
  name                  = "${var.environment}-kv-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.kv_dns.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false

  tags = var.tags
}

# DNS A record for private endpoint
resource "azurerm_private_dns_a_record" "kv_dns_record" {
  name                = azurerm_key_vault.kv.name
  zone_name           = azurerm_private_dns_zone.kv_dns.name
  resource_group_name = var.resource_group_name
  ttl                 = 10
  records             = [azurerm_private_endpoint.kv_pe.private_service_connection[0].private_ip_address]

  tags = var.tags
}

# RBAC role assignment for service principal (if provided)
resource "azurerm_role_assignment" "service_principal_kv_admin" {
  count              = var.service_principal_object_id != "" ? 1 : 0
  scope              = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id       = var.service_principal_object_id
}

resource "azurerm_role_assignment" "app_service_kv_secrets_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.app_service_principal_id
}

# Key Vault Secrets User for AKS kubelet managed identity
resource "azurerm_role_assignment" "aks_kv_secrets_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.aks_principal_id
}

