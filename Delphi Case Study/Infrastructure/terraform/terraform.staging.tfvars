# Variables for Staging Environment

subscription_id = "REPLACE_WITH_YOUR_SUBSCRIPTION_ID"

resource_group_name = "rg-delphi-staging"
location             = "East US 2"
environment          = "staging"

# Networking
vnet_cidr                   = ["10.0.0.0/8"]
aks_subnet_cidr             = "10.1.0.0/16"
app_service_subnet_cidr     = "10.2.0.0/16"
availability_zones          = ["1", "2"]

# AKS with smaller footprint for staging
kubernetes_version  = "1.27"
aks_node_count      = 2
aks_min_node_count  = 1
aks_max_node_count  = 3
aks_vm_size         = "Standard_D2s_v3"
service_cidr        = "10.0.0.0/16"
dns_service_ip      = "10.0.0.10"

# ACR
registry_name = "delphi-staging-registry"

# Key Vault
key_vault_name = "delphi-staging-kv"

# App Service
app_service_plan_name = "delphi-staging-app-plan"
app_service_name      = "delphi-staging-app-service"
app_service_sku       = "B2"  # Lower tier for staging
app_service_runtime   = "DOTNETCORE|7.0"
app_service_instance_count = 1

# Tags
tags = {
  Project       = "Delphi Case Study"
  Environment   = "Staging"
  ManagedBy     = "Terraform"
  CostCenter    = "Engineering"
  Owner         = "DevOps Team"
  CreatedDate   = "2024"
}
