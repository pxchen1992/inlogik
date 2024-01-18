variable "resource_group_name" {
  type        = string
  description = "resource group"
}

variable "resource_group_location" {
  type        = string
  description = "resource group location"
}

variable "service_principal_name" {
  description = "The name of the Azure AD Application and Service Principal."
  type        = string
}
