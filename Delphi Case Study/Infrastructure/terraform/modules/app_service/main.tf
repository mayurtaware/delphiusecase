terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# App Service Plan for high availability
resource "azurerm_service_plan" "app_service_plan" {
  name                = "${var.environment}-${var.app_service_plan_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name

  tags = var.tags
}

# App Service
resource "azurerm_linux_web_app" "app_service" {
  name                = "${var.environment}-${var.app_service_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  # Client affinity disabled for better loadbalancing across instances
  client_affinity_enabled = false

  # HTTPS only configuration
  https_only = var.enable_https_only

  # Function app configuration
  app_settings = merge(
    {
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
      /*
      "DOCKER_REGISTRY_SERVER_URL"          = "https://${var.acr_login_server}"
      "DOCKER_ENABLE_CI"                    = "true"
      "WEBSITES_PORT"                       = "80"
      */
      "ASPNETCORE_ENVIRONMENT"              = var.environment
      "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
      "WEBSITE_RUN_FROM_PACKAGE"                     = "1"
      "APPINSIGHTS_INSTRUMENTATIONKEY"               = var.app_insights_instrumentation_key
      "APPLICATIONINSIGHTS_CONNECTION_STRING"        = var.app_insights_connection_string
      "XDT_MicrosoftApplicationInsights_Mode"        = "Recommended"
      "ASPNETCORE_LOGGING__CONSOLE__DISABLECOLORS"   = "true"
    },
    var.app_settings
  )

  site_config {
    always_on                = true
    #container_registry_use_managed_identity = true
    
    /*
    application_stack {
      docker_image_name   = var.docker_image_name
      docker_registry_url = "https://${var.acr_login_server}"
    }
    */

    application_stack {
      dotnet_version = "8.0"
    }

    ftps_state                        = "Disabled"
    health_check_eviction_time_in_min = 5


    # Security settings
    http2_enabled                    = true
    minimum_tls_version              = var.minimum_tls_version
    scm_minimum_tls_version          = var.minimum_tls_version
    scm_use_main_ip_restriction      = true
    websockets_enabled               = false
    managed_pipeline_mode            = "Integrated"
    health_check_path                = "/"
    
    # Cors settings
    cors {
      allowed_origins     = ["*"]
      support_credentials = false
    }
  }

  # Identity for managed access to Key Vault and ACR
  identity {
    type = "SystemAssigned"
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    http_logs {
      retention_in_days = 7
    }
  }

  # VNet integration for secure access
  virtual_network_subnet_id = var.vnet_subnet_id

  tags = var.tags

  depends_on = [azurerm_service_plan.app_service_plan]
}

/*
# Autoscale settings for high availability
resource "azurerm_monitor_autoscale_setting" "app_service_autoscale" {
  name                = "${var.environment}-app-service-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_service_plan.app_service_plan.id

  profile {
    name = "default"

    capacity {
      default = var.instance_count
      minimum = var.instance_count
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name              = "CpuPercentage"
        metric_resource_id       = azurerm_service_plan.app_service_plan.id
        time_grain               = "PT1M"
        statistic                = "Average"
        time_window              = "PT5M"
        time_aggregation         = "Average"
        operator                 = "GreaterThan"
        threshold                = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name              = "CpuPercentage"
        metric_resource_id       = azurerm_service_plan.app_service_plan.id
        time_grain               = "PT1M"
        statistic                = "Average"
        time_window              = "PT5M"
        time_aggregation         = "Average"
        operator                 = "LessThan"
        threshold                = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }
  }

  tags = var.tags
}

# Storage Account for backup and diagnostics
resource "azurerm_storage_account" "app_storage" {
  name                     = "app${replace(var.environment, "-", "")}stor"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  https_traffic_only_enabled = true
  min_tls_version          = "TLS1_2"

  tags = var.tags
}
*/

# Private Endpoint for App Service (if needed)
resource "azurerm_private_endpoint" "app_service_pe" {
  name                = "${var.environment}-app-service-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.environment}-app-service-psc"
    private_connection_resource_id = azurerm_linux_web_app.app_service.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  tags = var.tags
}


# Private DNS Zone for App Service
resource "azurerm_private_dns_zone" "app_service_dns" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "app_service_dns_link" {
  name                  = "${var.environment}-app-service-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.app_service_dns.name
  virtual_network_id    = var.vnet_id

  tags = var.tags
}

# DNS A record for private endpoint
resource "azurerm_private_dns_a_record" "app_service_dns_record" {
  name                = "${var.environment}-${var.app_service_name}"
  zone_name           = azurerm_private_dns_zone.app_service_dns.name
  resource_group_name = var.resource_group_name
  ttl                 = 10
  records             = [azurerm_private_endpoint.app_service_pe.private_service_connection[0].private_ip_address]

  tags = var.tags
}

# Application Insights for monitoring (optional)
/*
resource "azurerm_application_insights" "app_insights" {
  name                = "${var.environment}-${var.app_service_name}-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  sampling_percentage = 100
  retention_in_days   = 90

  tags = var.tags
}
*/

/*
# Diagnostic settings for App Service
resource "azurerm_monitor_diagnostic_setting" "app_service_diagnostics" {
  name               = "${var.environment}-app-service-diagnostics"
  target_resource_id = azurerm_linux_web_app.app_service.id
  storage_account_id = azurerm_storage_account.app_storage.id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
*/
