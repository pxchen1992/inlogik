# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location              = var.resource_group_location
  include_preview       = false  
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = var.aks_name
  location                  = var.resource_group_location
  resource_group_name       = var.resource_group_name
  dns_prefix                = "${var.resource_group_name}-cluster" 
  kubernetes_version        =  data.azurerm_kubernetes_service_versions.current.latest_version
  

   default_node_pool {
    name                    = "default"
    vm_size                 = "Standard_DS2_v2"
    enable_auto_scaling     = true
    max_count               = 3
    min_count               = 1
    os_disk_size_gb         = 30
    vnet_subnet_id          = var.aks_subnet_id
    enable_node_public_ip   = false
  }

  service_principal  {
    client_id               = var.client_id
    client_secret           = var.client_secret
  }
  
  local_account_disabled    = false

  azure_active_directory_role_based_access_control {
    managed                 = true
    azure_rbac_enabled      = true
  }

  network_profile {
      network_plugin        = "azure"
      load_balancer_sku     = "standard"
      service_cidr          = "192.168.0.0/16"         
      docker_bridge_cidr    = "192.167.0.1/16"          
      dns_service_ip        = "192.168.1.1"            
  }
}
