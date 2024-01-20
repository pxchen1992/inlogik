resource "azurerm_container_registry" "acr" {
  name                = "inlogik"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "Premium"

  # Enable the username password
  # admin_enabled       = true
  # georeplications {
  #   location                = "East US"
  #   zone_redundancy_enabled = true
  # }
}