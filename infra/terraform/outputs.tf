output "container_app_fqdn" {
  description = "FQDN of the deployed n8n Azure Container App."
  value       = azurerm_container_app.app.ingress[0].fqdn
}

output "container_app_url" {
  description = "Public HTTPS URL of the deployed n8n Azure Container App."
  value       = "https://${azurerm_container_app.app.ingress[0].fqdn}"
}

