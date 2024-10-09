# Configure the Azure provider
data "azuread_client_config" "current" {}

terraform {
    required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
  }

  required_version = ">= 1.7.0"
  
}

# Configure the Azure Resource Provider
provider "azurerm" {
  features {
    key_vault {
      # available in 2.x
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true

      # available when opted into the 3.0 Beta
      purge_soft_deleted_certificates_on_destroy = true
      purge_soft_deleted_keys_on_destroy         = true
      purge_soft_deleted_secrets_on_destroy      = true
      recover_soft_deleted_certificates          = true
      recover_soft_deleted_secrets               = true
      recover_soft_deleted_keys                  = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Configure the Azure Active Directory Provider
provider "azuread" {
  tenant_id = data.azurerm_client_config.current.tenant_id
  #use_microsoft_graph = true
}

# Retrieve domain information
data "azuread_domains" "aad_domains" {}

output "domain_names" {
  description = " Azure AD domain name is: "  
  value = data.azuread_domains.aad_domains.domains.*.domain_name
}

# Configure the Kubernetes provider
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.firstaks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.firstaks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.firstaks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.firstaks.kube_config.0.cluster_ca_certificate)
}

