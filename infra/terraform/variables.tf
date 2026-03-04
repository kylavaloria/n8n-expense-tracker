variable "subscription_id" {
  description = "Azure subscription ID used for deployment."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Project identifier used in resource naming."
  type        = string
  default     = "n8nexpense"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group."
  type        = string
  default     = "rg-n8n-expense"
}

variable "log_analytics_workspace_name" {
  description = "Optional custom name for Log Analytics workspace."
  type        = string
  default     = null
}

variable "container_app_environment_name" {
  description = "Optional custom name for Container Apps environment."
  type        = string
  default     = null
}

variable "container_app_name" {
  description = "Name of the n8n Azure Container App."
  type        = string
  default     = "n8n-app"
}

variable "storage_account_name" {
  description = "Optional custom storage account name (3-24 lowercase alphanumeric)."
  type        = string
  default     = null
}

variable "storage_share_name" {
  description = "Name of the Azure file share for persistent n8n data."
  type        = string
  default     = "n8n-data"
}

variable "container_cpu" {
  description = "CPU allocation for the n8n container."
  type        = number
  default     = 0.5
}

variable "container_memory" {
  description = "Memory allocation for the n8n container."
  type        = string
  default     = "1Gi"
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
  description = "Optional explicit webhook URL. If null, defaults to the expected Container App URL."
  type        = string
  default     = null
}

