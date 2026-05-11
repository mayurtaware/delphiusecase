subscription_id = "1669456d-f3fe-4487-ae88-7175a7259aff"

resource_group_name = "rg-delphi-prod"
location             = "uaenorth"
environment          = "prod"

# Networking
vnet_cidr                   = ["10.0.0.0/8"]
aks_subnet_cidr             = "10.1.0.0/16"
app_service_subnet_cidr     = "10.2.0.0/16"
private_endpoint_subnet_cidr = "10.3.0.0/16"
availability_zones          = ["1"]  # uaenorth only supports zone 1

# AKS
kubernetes_version  = "1.32.10"
aks_node_count      = 1
#aks_min_node_count  = 1
#aks_max_node_count  = 5
aks_vm_size         = "Standard_D2s_v3"
service_cidr        = "10.0.0.0/16"
dns_service_ip      = "10.0.0.10"

# ACR
registry_name = "delphi-app-registry"

# Key Vault
key_vault_name = "delphi-prod-kv"

# App Service
app_service_plan_name = "delphi-app-plan"
app_service_name      = "delphi-app-service"
app_service_sku       = "S2"
app_service_runtime   = "DOTNETCORE|7.0"
app_service_instance_count = 2

# Tags
tags = {
  Project       = "Delphi Case Study"
  Environment   = "Production"
  ManagedBy     = "Terraform"
  CostCenter    = "Engineering"
  Owner         = "DevOps Team"
  CreatedDate   = "2024"
}
