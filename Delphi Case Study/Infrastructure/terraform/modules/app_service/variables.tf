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

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
}

variable "sku_name" {
  description = "SKU for App Service Plan"
  type        = string
  default     = "P1V2"
}

variable "os_type" {
  description = "OS type for App Service"
  type        = string
  default     = "Linux"
}

variable "runtime_version" {
  description = "Runtime version"
  type        = string
  default     = "DOTNETCORE|7.0"
}

variable "vnet_subnet_id" {
  description = "Virtual network subnet ID for App Service integration"
  type        = string
}

variable "vnet_id" {
  description = "Virtual network ID"
  type        = string
}

variable "app_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "key_vault_id" {
  description = "Key Vault ID for secret references"
  type        = string
}

variable "acr_login_server" {
  description = "ACR login server URL"
  type        = string
}

variable "docker_image_name" {
  description = "Docker image name in ACR"
  type        = string
  default     = "app:latest"
}

variable "enable_https_only" {
  description = "Enable HTTPS only"
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "app_settings" {
  description = "App settings for the App Service"
  type        = map(string)
  default     = {}
}

variable "instance_count" {
  description = "Number of App Service instances"
  type        = number
  default     = 2
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint (cannot be delegated)"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
