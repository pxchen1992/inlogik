variable "resource_group_name" {
  type = string
  description = "resource group"
  default = "inlogik"
}

variable "resource_group_location" {
  type = string
  description = "resource group location"
  default = "Australia East"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default = "inlogik-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default = [ "10.0.0.0/8" ]
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
  default = "aks-subnet"
}

variable "aks_subnet_prefix" {
  description = "Subnet address prefix for the AKS cluster"
  type        = string
  default = "10.240.0.0/16"
}

variable "ag_subnet_prefix" {
    description = "subnet address prefix for the application gateway"
    type = string
    default = "10.21.0.0/16"
  
}

variable "service_principal_name" {
  description = "The name of the Azure AD Application and Service Principal."
  type        = string
  default = "inlogik"
}

variable "aks_name" {
  default = "chen-aks"
}

variable "ag_subnet_name" {
  description = "Name of the application gateway frontend subnet"
  type = string
  default = "ag-subnet"
}

variable "gateway_name" {
  description = "Name of the application gateway"
  type = string
  default = "inlogik-gateway"
}

variable "subscriptionId" {}
variable "spSecret" {}
variable "tenantId" {}
variable "clientId" {}