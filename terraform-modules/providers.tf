terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }

    azuread = {
      version = ">= 2.26.0" // https://github.com/terraform-providers/terraform-provider-azuread/releases
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}

provider "kubernetes" {
  host                   = module.aks.kube_admin_config.0.host
  client_certificate     = base64decode(module.aks.kube_admin_config.0.client_certificate)
  client_key             = base64decode(module.aks.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_admin_config.0.cluster_ca_certificate)
}

provider "helm" {
  debug = true
  kubernetes {
    host                   = module.aks.kube_admin_config.0.host
    client_certificate     = base64decode(module.aks.kube_admin_config.0.client_certificate)
    client_key             = base64decode(module.aks.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(module.aks.kube_admin_config.0.cluster_ca_certificate)

  }
}
provider "kubectl" {
  host                   = module.aks.kube_admin_config.0.host
  client_certificate     = base64decode(module.aks.kube_admin_config.0.client_certificate)
  client_key             = base64decode(module.aks.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_admin_config.0.cluster_ca_certificate)
  load_config_file       = false
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
  }
}