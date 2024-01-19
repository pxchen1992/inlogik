# Network Security Group for AKS Subnet
resource "azurerm_network_security_group" "aks_nsg" {
  name                = "aks-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# Association the subnet with the NSG
resource "azurerm_subnet_network_security_group_association" "aks_nsg_assoc" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}

# Define rules for the Network Security Group for subnet (e.g: allow HTTP and HTTPS)
resource "azurerm_network_security_rule" "http" {
  name                          = "allow-http"
  priority                      = 1001
  direction                     = "Inbound"
  access                        = "Allow"
  protocol                      = "Tcp"
  source_port_range             = "*"
  destination_port_range        = "80"
  source_address_prefix         = "*"
  destination_address_prefix    = "*"
  resource_group_name           = var.resource_group_name
  network_security_group_name   = azurerm_network_security_group.aks_nsg.name
}

resource "azurerm_network_security_rule" "https" {
  name                          = "allow-https"
  priority                      = 1002
  direction                     = "Inbound"
  access                        = "Allow"
  protocol                      = "Tcp"
  source_port_range             = "*"
  destination_port_range        = "443"
  source_address_prefix         = "*"
  destination_address_prefix    = "*"
  resource_group_name           = var.resource_group_name
  network_security_group_name   = azurerm_network_security_group.aks_nsg.name
}

# resource "azurerm_network_security_rule" "prometheus" {
#   name                          = "prometheus-allow"
#   priority                      = 1003
#   direction                     = "Inbound"
#   access                        = "Allow"
#   protocol                      = "Tcp"
#   source_port_range             = "*"
#   destination_port_range        = "9090"
#   source_address_prefix         = "*"
#   destination_address_prefix    = "*"
#   resource_group_name           = var.resource_group_name
#   network_security_group_name   = azurerm_network_security_group.aks_nsg.name
# }

# resource "azurerm_network_security_rule" "grafana" {
#   name                          = "grafana-allow"
#   priority                      = 1004
#   direction                     = "Inbound"
#   access                        = "Allow"
#   protocol                      = "Tcp"
#   source_port_range             = "*"
#   destination_port_range        = "3000"
#   source_address_prefix         = "*"
#   destination_address_prefix    = "*"
#   resource_group_name           = var.resource_group_name
#   network_security_group_name   = azurerm_network_security_group.aks_nsg.name
# }

