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