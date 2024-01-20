output "aks_subnet_id" {
  description = "aks subnet ID"
  value = azurerm_subnet.aks_subnet.id
}

output "network_security_group_id" {
  value = azurerm_network_security_group.aks_nsg.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}