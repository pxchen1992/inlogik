# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location              = azurerm_resource_group.rg.location
  include_preview       = false  
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = var.aks_name
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  dns_prefix                = "${var.resource_group_name}-cluster" 
  kubernetes_version        =  data.azurerm_kubernetes_service_versions.current.latest_version
  

   default_node_pool {
    name                    = "default"
    vm_size                 = "Standard_DS2_v2"
    enable_auto_scaling     = true
    max_count               = 3
    min_count               = 1
    os_disk_size_gb         = 30
    vnet_subnet_id          = azurerm_subnet.aks-subnet.id
    enable_node_public_ip   = false
  }

  service_principal  {
    client_id               = azuread_service_principal.main.application_id
    client_secret           = azuread_service_principal_password.main.value
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

    ingress_application_gateway {
      subnet_id = azurerm_subnet.frontend-ag.id
      gateway_name = azurerm_application_gateway.gateway.name
    }
}


# Namespace for UAT
resource "kubernetes_namespace" "uat" {
  metadata {
    name = "uat"
  }
}

# Namespace for Production
resource "kubernetes_namespace" "prod" {
  metadata {
    name = "prod"
  }
}

