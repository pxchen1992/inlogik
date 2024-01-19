# Resource Group
module "rg" {
  source                      = "./modules/rg"
  resource_group_name         = var.resource_group_name
  resource_group_location     = var.resource_group_location
}

# Azure Container Registry
module "acr" {
  source                      = "./modules/acr"
  resource_group_name         = module.rg.resource_group_name
  resource_group_location     = module.rg.resource_group_location
}

# Service Principal
module "service_principal" {
  source                      = "./modules/service_principal"
  service_principal_name      = var.service_principal_name
  # aks_cluster_id              = module.aks.aks_cluster_id
}

# AKS
module "aks" {
  source                      = "./modules/aks"
  resource_group_name         = module.rg.resource_group_name
  resource_group_location     = module.rg.resource_group_location
  client_id                   = module.service_principal.client_id
  client_secret               = module.service_principal.client_secret
  aks_subnet_id               = module.networking.aks_subnet_id
  aks_name                    = var.aks_name
  service_principal_name      = var.service_principal_name
  
  depends_on                  = [module.service_principal]
}

# Vnet & Subnet 
module "networking" {
  source                      = "./modules/networking"
  resource_group_name         = module.rg.resource_group_name
  resource_group_location     = module.rg.resource_group_location
  vnet_name                   = var.vnet_name
  vnet_address_space          = var.vnet_address_space
  aks_subnet_name             = var.aks_subnet_name
  aks_subnet_prefix           = var.aks_subnet_prefix
}