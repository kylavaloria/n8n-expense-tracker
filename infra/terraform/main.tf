locals {
  project_name_sanitized      = lower(regexreplace(var.project_name, "[^a-z0-9]", ""))
  project_name_compact        = length(local.project_name_sanitized) > 0 ? local.project_name_sanitized : "n8nexpense"
  log_analytics_workspace     = coalesce(var.log_analytics_workspace_name, "log-${var.project_name}")
  container_app_environment   = coalesce(var.container_app_environment_name, "cae-${var.project_name}")
  webhook_url_effective       = coalesce(var.webhook_url, "https://${var.container_app_name}.${azurerm_container_app_environment.env.default_domain}")
}

# Generates a short suffix to keep globally-unique resource names (for storage account).
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

# Creates the resource group that contains all n8n infrastructure resources.
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Provides centralized logging for Azure Container Apps diagnostics and revisions.
resource "azurerm_log_analytics_workspace" "law" {
  name                = local.log_analytics_workspace
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Creates the Azure Container Apps environment that hosts the n8n Container App.
resource "azurerm_container_app_environment" "env" {
  name                       = local.container_app_environment
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

# Stores persistent n8n workflow/state data in Azure Files.
resource "azurerm_storage_account" "sa" {
  name                     = coalesce(var.storage_account_name, substr("${local.project_name_compact}${random_string.suffix.result}", 0, 24))
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

# Provisions an Azure File Share used by n8n for durable data at /home/node/.n8n.
resource "azurerm_storage_share" "n8n" {
  name                 = var.storage_share_name
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 50
}

# Registers the Azure File Share with the Container Apps environment for volume mounting.
resource "azurerm_container_app_environment_storage" "n8n_files" {
  name                         = "n8nfiles"
  container_app_environment_id = azurerm_container_app_environment.env.id
  account_name                 = azurerm_storage_account.sa.name
  share_name                   = azurerm_storage_share.n8n.name
  access_key                   = azurerm_storage_account.sa.primary_access_key
  access_mode                  = "ReadWrite"
}

# Deploys the official n8n container with HTTPS ingress, secrets, and persistent Azure Files storage.
resource "azurerm_container_app" "app" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  ingress {
    external_enabled = true
    target_port      = 5678
    transport        = "auto"
  }

  secret {
    name  = "n8n-encryption-key"
    value = var.n8n_encryption_key
  }

  secret {
    name  = "openrouter-api-key"
    value = var.openrouter_api_key
  }

  secret {
    name  = "telegram-id"
    value = var.telegram_id
  }

  template {
    container {
      name   = "n8n"
      image  = "n8nio/n8n:latest"
      cpu    = var.container_cpu
      memory = var.container_memory

      env {
        name        = "N8N_ENCRYPTION_KEY"
        secret_name = "n8n-encryption-key"
      }

      env {
        name  = "N8N_PORT"
        value = "5678"
      }

      env {
        name  = "N8N_PROTOCOL"
        value = "https"
      }

      env {
        name  = "WEBHOOK_URL"
        value = local.webhook_url_effective
      }

      env {
        name        = "OPENROUTER_API_KEY"
        secret_name = "openrouter-api-key"
      }

      env {
        name        = "Telegram_Id"
        secret_name = "telegram-id"
      }

      volume_mounts {
        name = "n8n-data"
        path = "/home/node/.n8n"
      }
    }

    volume {
      name         = "n8n-data"
      storage_name = azurerm_container_app_environment_storage.n8n_files.name
      storage_type = "AzureFile"
    }
  }
}

