variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "environment" {
  description = "Environment name (prod, staging, dev)"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "sku_name" {
  description = "SKU of the Key Vault"
  type        = string
  default     = "premium"
}

variable "enable_rbac_authorization" {
  description = "Enable RBAC authorization"
  type        = bool
  default     = true
}

variable "enabled_for_disk_encryption" {
  description = "Enable disk encryption"
  type        = bool
  default     = false
}

variable "enabled_for_deployment" {
  description = "Enable deployment"
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Enable template deployment"
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention days"
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Enable purge protection"
  type        = bool
  default     = true
}

variable "vnet_subnet_id" {
  description = "Virtual network subnet ID for private endpoint"
  type        = string
}

variable "vnet_id" {
  description = "Virtual network ID"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "secret_permissions" {
  description = "Permissions for secrets"
  type        = list(string)
  default     = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
}

variable "key_permissions" {
  description = "Permissions for keys"
  type        = list(string)
  default     = ["Get", "List", "Create", "Delete", "Update", "Recover", "Backup", "Restore"]
}

variable "certificate_permissions" {
  description = "Permissions for certificates"
  type        = list(string)
  default     = ["Get", "List", "Create", "Delete", "Update"]
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostics (optional)"
  type        = string
  default     = ""
}

variable "service_principal_object_id" {
  description = "Object ID of the service principal to grant Key Vault permissions"
  type        = string
  default     = ""
}


variable "app_service_principal_id" {
  description = "Object ID of the App Service system-assigned managed identity"
  type        = string
}

variable "aks_principal_id" {
  description = "Object ID of the AKS kubelet managed identity"
  type        = string
}