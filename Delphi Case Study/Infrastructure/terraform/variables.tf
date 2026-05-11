variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name (prod, staging, dev)"
  type        = string
  default     = "prod"
  validation {
    condition     = contains(["prod", "staging", "dev"], var.environment)
    error_message = "Environment must be prod, staging, or dev."
  }
}

# Networking variables
variable "vnet_cidr" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "aks_subnet_cidr" {
  description = "Address space for AKS subnet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "app_service_subnet_cidr" {
  description = "Address space for App Service subnet"
  type        = string
  default     = "10.2.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for resources"
  type        = list(string)
  default     = ["1", "2", "3"]
}

# AKS variables
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27"
}

variable "aks_node_count" {
  description = "Initial number of nodes in AKS"
  type        = number
  default     = 3
}

variable "aks_min_node_count" {
  description = "Minimum number of nodes in AKS"
  type        = number
  default     = 2
}

variable "aks_max_node_count" {
  description = "Maximum number of nodes in AKS"
  type        = number
  default     = 5
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "service_cidr" {
  description = "Service CIDR for AKS"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "DNS Service IP for AKS"
  type        = string
  default     = "10.0.0.10"
}

# ACR variables
variable "registry_name" {
  description = "Name of the container registry"
  type        = string
}

# Key Vault variables
variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

# App Service variables
variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
}

variable "app_service_sku" {
  description = "SKU for App Service Plan"
  type        = string
  default     = "P1V2"
}

variable "app_service_runtime" {
  description = "Runtime for App Service"
  type        = string
  default     = "DOTNETCORE|7.0"
}

variable "app_service_instance_count" {
  description = "Number of App Service instances"
  type        = number
  default     = 2
}

# Common tags
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "Delphi Case Study"
    Environment = "Production"
    ManagedBy   = "Terraform"
    CreatedDate = "2024"
  }
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostics (optional)"
  type        = string
  default     = ""
}
