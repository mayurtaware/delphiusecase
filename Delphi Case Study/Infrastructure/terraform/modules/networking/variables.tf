variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "environment" {
  description = "Environment name (prod, staging, dev)"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

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

variable "private_endpoint_subnet_cidr" {
  description = "CIDR block for the private endpoint subnet"
  type        = string
}



variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
