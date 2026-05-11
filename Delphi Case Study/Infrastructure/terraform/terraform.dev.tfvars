# Variables for Development Environment

subscription_id = "REPLACE_WITH_YOUR_SUBSCRIPTION_ID"

resource_group_name = "rg-delphi-dev"
location             = "East US"
environment          = "dev"

# Networking
vnet_cidr                   = ["10.0.0.0/8"]
aks_subnet_cidr             = "10.1.0.0/16"
app_service_subnet_cidr     = "10.2.0.0/16"
availability_zones          = ["1"]  # Single zone for dev

# AKS with minimal footprint for dev
kubernetes_version  = "1.27"
aks_node_count      = 1
aks_min_node_count  = 1
aks_max_node_count  = 2
aks_vm_size         = "Standard_B2s"  # Lower tier for dev
service_cidr        = "10.0.0.0/16"
dns_service_ip      = "10.0.0.10"

# ACR
registry_name = "delphi-dev-registry"

# Key Vault
key_vault_name = "delphi-dev-kv"

# App Service
app_service_plan_name = "delphi-dev-app-plan"
app_service_name      = "delphi-dev-app-service"
app_service_sku       = "B1"  # Minimal tier for dev
app_service_runtime   = "DOTNETCORE|7.0"
app_service_instance_count = 1

# Tags
tags = {
  Project       = "Delphi Case Study"
  Environment   = "Development"
  ManagedBy     = "Terraform"
  CostCenter    = "Engineering"
  Owner         = "DevOps Team"
  CreatedDate   = "2024"
}
