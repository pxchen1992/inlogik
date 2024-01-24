# Vnet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
}

# Subnet for aks
resource "azurerm_subnet" "aks-subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.aks_subnet_prefix]
}

# Subnet for application gateway
resource "azurerm_subnet" "frontend-ag" {
  name                 = var.ag_subnet_name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.ag_subnet_prefix ]

}

# create public IP for application gateway
resource "azurerm_public_ip" "publicip" {
  name                = "inlogik-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# # Grant permission on a vnet subnet to allow an application gateway to deploy agic
# data "azurerm_subscription" "current" {}
# data "azurerm_client_config" "current" {}

# resource "azurerm_role_assignment" "gateway_subnet" {
#   scope                = azurerm_subnet.frontend-ag.id
#   role_definition_name = "Network Contributor"
#   principal_id         = "190f2af4-5cf0-4b15-802e-d9594c4554f6"
# }