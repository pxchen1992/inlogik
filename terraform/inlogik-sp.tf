data "azuread_client_config" "current" {}

resource "azuread_application" "main" {
  display_name = var.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "main" {
  application_id               = azuread_application.main.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.object_id
}

# Role Assignment for service principal
resource "azurerm_role_assignment" "rolespn" {
  scope                       = azurerm_kubernetes_cluster.aks.id
  role_definition_name        = "Contributor" #it has access to get and put keys to the key vault
  principal_id                = azuread_service_principal.main.id
}