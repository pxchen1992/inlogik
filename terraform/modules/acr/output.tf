output "acr_url" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_user" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_admin_pwd" {
  value = azurerm_container_registry.acr.admin_password
}