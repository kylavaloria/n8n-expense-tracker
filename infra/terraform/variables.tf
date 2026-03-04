variable "subscription_id" {
  description = "Azure subscription ID used for deployment."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure resource group."
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name for Log Analytics workspace."
  type        = string
}

variable "container_app_environment_name" {
  description = "Name for Container Apps environment."
  type        = string
}

variable "container_app_name" {
  description = "Name of the n8n Azure Container App."
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name (3-24 lowercase alphanumeric, globally unique)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3-24 lowercase letters and digits only."
  }
}

variable "storage_share_name" {
  description = "Name of the Azure file share for persistent n8n data."
  type        = string
}

variable "n8n_encryption_key" {
  description = "Encryption key used by n8n."
  type        = string
  sensitive   = true
}

variable "openrouter_api_key" {
  description = "API key used by n8n workflows for OpenRouter."
  type        = string
  sensitive   = true
}

variable "telegram_id" {
  description = "Telegram chat or user ID used by workflows."
  type        = string
  sensitive   = true
}

variable "webhook_url" {
  description = "Public HTTPS webhook URL for n8n."
  type        = string
}

