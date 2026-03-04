location                       = "eastus"
resource_group_name            = "rg-n8n-expense-prod-eastus"
log_analytics_workspace_name   = "law-n8n-expense-prod-eastus"
container_app_environment_name = "cae-n8n-expense-prod-eastus"
container_app_name             = "n8n-expense-prod-eastus"
storage_account_name           = "n8nexpenseprodeus01"
storage_share_name             = "n8n-data-prod"
webhook_url                    = "https://n8n-expense-prod-eastus.eastus.azurecontainerapps.io"

# Provide secrets via masked environment variables:
# TF_VAR_subscription_id=***masked***
# TF_VAR_n8n_encryption_key=***masked***
# TF_VAR_openrouter_api_key=***masked***
# TF_VAR_telegram_id=***masked***

