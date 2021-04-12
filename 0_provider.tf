terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.54.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "=2.0.3"
    }
    helm = {
      source = "hashicorp/helm"
      version = "=2.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    host                   = module.k8s.host
    client_certificate     = base64decode(module.k8s.client_certificate)
    client_key             = base64decode(module.k8s.client_key)
    cluster_ca_certificate = base64decode(module.k8s.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                     = module.k8s.host
  client_key               = base64decode(module.k8s.client_key)
  client_certificate       = base64decode(module.k8s.client_certificate)
  cluster_ca_certificate   = base64decode(module.k8s.cluster_ca_certificate)
}
