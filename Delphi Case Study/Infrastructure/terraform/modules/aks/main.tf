terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Generate SSH key for AKS
resource "tls_private_key" "aks_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AKS Cluster with High Availability Configuration
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.environment}-aks-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.environment}-aks"
  kubernetes_version  = var.kubernetes_version

  # Enable API Server authorized IP ranges for security
  api_server_access_profile {
    authorized_ip_ranges = []
  }

  # Default node pool configuration
  default_node_pool {
    name               = "default"
    node_count         = var.node_count
    #min_count          = var.min_node_count
    #max_count          = var.max_node_count
    vm_size            = var.vm_size
    enable_auto_scaling = false
    vnet_subnet_id     = var.vnet_subnet_id
    #zones              = var.availability_zones

    node_labels = {
      environment = var.environment
      workload    = "general"
    }

    tags = merge(
      var.tags,
      {
        NodeType = "Default"
      }
    )
  }

  # Linux profile for SSH access
  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = tls_private_key.aks_key.public_key_openssh
    }
  }

  # Network profile with specific CIDR blocks
  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
    load_balancer_sku  = "standard"
    outbound_type      = "loadBalancer"
  }

  # Identity configuration
  identity {
    type = "SystemAssigned"
  }

  # Enable Azure Policy for compliance
  azure_policy_enabled = var.enable_azure_policy

  # Enable Workload Identity for secure pod authentication
  oidc_issuer_enabled       = var.enable_workload_identity
  workload_identity_enabled = var.enable_workload_identity

  # Enable monitoring
  monitor_metrics {
  annotations_allowed = "prometheus.io/scrape"   # Which annotations to scrape
  labels_allowed      = "app,component" 
  }

  tags = var.tags

  depends_on = [tls_private_key.aks_key]
}

# Azure role assignment for ACR pull access
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope              = var.acr_id
  role_definition_name = "AcrPull"
  principal_id       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# Note: SSH key storage in Key Vault has been removed for initial deployment
/*
resource "azurerm_key_vault_secret" "aks_ssh_private_key" {
  name         = "${var.environment}-aks-ssh-private-key"
  value        = tls_private_key.aks_key.private_key_pem
  key_vault_id = var.key_vault_id

  tags = var.tags
}
*/


# Additional node pool for system workloads
/*
resource "azurerm_kubernetes_cluster_node_pool" "system" {
  name                  = "system"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  node_count            = 1
  #min_count             = 1
  #max_count             = 3
  vm_size               = "Standard_D2s_v3"
  enable_auto_scaling   = false
  zones                 = var.availability_zones
  vnet_subnet_id        = var.vnet_subnet_id

  node_labels = {
    workload = "system"
  }

  tags = merge(
    var.tags,
    {
      NodeType = "System"
    }
  )
}
*/

# Additional node pool for application workloads
/*
resource "azurerm_kubernetes_cluster_node_pool" "application" {
  name                  = "application"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  node_count            = 1
  #min_count             = 1
  #max_count             = 5
  vm_size               = "Standard_D4s_v3"
  enable_auto_scaling   = false
  zones                 = var.availability_zones
  vnet_subnet_id        = var.vnet_subnet_id

  node_labels = {
    workload = "application"
  }

  tags = merge(
    var.tags,
    {
      NodeType = "Application"
    }
  )
}
*/
