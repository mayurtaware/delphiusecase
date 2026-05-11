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

variable "registry_name" {
  description = "Name of the container registry"
  type        = string
}

variable "sku" {
  description = "SKU of the container registry"
  type        = string
  default     = "Premium"
}

variable "admin_enabled" {
  description = "Enable admin user"
  type        = bool
  default     = false
}

variable "vnet_subnet_id" {
  description = "Virtual network subnet ID for private endpoint"
  type        = string
}

variable "vnet_id" {
  description = "Virtual network ID"
  type        = string
}

variable "enable_content_trust" {
  description = "Enable content trust for image signing"
  type        = bool
  default     = true
}

variable "retention_policy_days" {
  description = "Number of days to retain untagged manifests"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for the ACR"
  type        = bool
  default     = false   # Default to secure
}
