output "acr_url" {
  value = azurerm_container_registry.acr.login_server
}

output "service_principal_object_id" {
  value = azuread_service_principal.main.object_id
}

output "service_principal_tenant_id" {
  value = azuread_service_principal.main.application_tenant_id
}

output "service_principal_application_id" {
  value = azuread_service_principal.main.application_id
}

output "client_id" {
  description = "The application id of AzureAD Application created"
  value       = azuread_application.main.client_id
}

output "client_secret" {
  description = "Password for service principal"
  value       = azuread_service_principal_password.main.value
  sensitive = true
}