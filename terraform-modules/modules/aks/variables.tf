variable "resource_group_name" {
  type        = string
}

variable "resource_group_location" {
  type        = string
}

variable "aks_name" {
    type = string
}

variable "client_id" {}

variable "client_secret" {
  type = string
  sensitive = true
}

variable "service_principal_name" {
  type = string
}

variable "aks_subnet_id" {
  description = "ID of the AKS subnet from the networking module"
}