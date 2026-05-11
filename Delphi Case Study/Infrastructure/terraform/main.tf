# Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Get current client context (service principal or user)
data "azurerm_client_config" "current" {}

# Networking Module
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment
  location            = var.location
  vnet_cidr           = var.vnet_cidr
  aks_subnet_cidr     = var.aks_subnet_cidr
  app_service_subnet_cidr = var.app_service_subnet_cidr
  private_endpoint_subnet_cidr = var.private_endpoint_subnet_cidr
  tags = var.tags
}

# Key Vault Module (created before other resources for secret management)
module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  environment         = var.environment
  key_vault_name      = var.key_vault_name
  sku_name            = "premium"
  vnet_subnet_id      = module.networking.private_endpoint_subnet_id
  vnet_id             = module.networking.vnet_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  service_principal_object_id = data.azurerm_client_config.current.object_id

  tags = var.tags

  depends_on = [azurerm_resource_group.rg, module.networking]
}

# ACR Module
module "acr" {
  source = "./modules/acr"

  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  environment          = var.environment
  registry_name        = var.registry_name
  sku                  = "Premium"
  
  admin_enabled        = false
  vnet_subnet_id       = module.networking.private_endpoint_subnet_id
  vnet_id              = module.networking.vnet_id
  enable_content_trust = true
  retention_policy_days = 30

  tags = var.tags

  depends_on = [azurerm_resource_group.rg, module.networking, module.keyvault]
}

# AKS Module
module "aks" {
  source = "./modules/aks"

  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  environment          = var.environment
  kubernetes_version   = var.kubernetes_version
  node_count           = var.aks_node_count
  min_node_count       = var.aks_min_node_count
  max_node_count       = var.aks_max_node_count
  vm_size              = var.aks_vm_size
  vnet_subnet_id       = module.networking.aks_subnet_id
  service_cidr         = var.service_cidr
  dns_service_ip       = var.dns_service_ip
  acr_id               = module.acr.acr_id
  key_vault_id         = module.keyvault.key_vault_id
  availability_zones   = var.availability_zones
  enable_azure_policy  = true
  enable_workload_identity = true

  tags = var.tags

  depends_on = [azurerm_resource_group.rg, module.networking, module.acr, module.keyvault]
}

# App Service Module
module "app_service" {
  source = "./modules/app_service"

  resource_group_name              = azurerm_resource_group.rg.name
  location                         = var.location
  environment                      = var.environment
  app_service_plan_name            = var.app_service_plan_name
  app_service_name                 = var.app_service_name
  sku_name                         = var.app_service_sku
  os_type                          = "Linux"
  runtime_version                  = var.app_service_runtime
  vnet_subnet_id                   = module.networking.app_service_subnet_id
  private_endpoint_subnet_id       = module.networking.private_endpoint_subnet_id
  vnet_id                          = module.networking.vnet_id
  key_vault_id                     = module.keyvault.key_vault_id
  acr_login_server                 = module.acr.acr_login_server
  enable_https_only                = true
  minimum_tls_version              = "1.2"
  instance_count                   = var.app_service_instance_count

  app_settings = {
    "KeyVaultUri"               = module.keyvault.key_vault_uri
    "ContainerRegistry"         = module.acr.acr_login_server
    "Environment"               = var.environment
    "AKS_FQDN"                  = module.aks.aks_fqdn
  }

  tags = var.tags

  depends_on = [azurerm_resource_group.rg, module.networking, module.keyvault, module.acr]
}

# RBAC Role Assignment - App Service access to Key Vault
resource "azurerm_role_assignment" "app_service_kv_access" {
  scope              = module.keyvault.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id       = module.app_service.app_service_identity_principal_id
}

# RBAC Role Assignment - App Service access to ACR
resource "azurerm_role_assignment" "app_service_acr_pull" {
  scope              = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id       = module.app_service.app_service_identity_principal_id
}
