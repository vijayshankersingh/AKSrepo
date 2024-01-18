resource "azurerm_kubernetes_cluster" "firstaks" {
  name                = "firstaks"
  location            = var.region
  resource_group_name = var.resourcegroup
  dns_prefix  = "firstaks"
  private_cluster_enabled = false
  azure_policy_enabled = true
  key_vault_secrets_provider {
    secret_rotation_enabled = true
   # secret_rotation_interval = 30m/
  }
  kubernetes_version = "1.27.7"
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr = "10.0.4.0/24"
    dns_service_ip = "10.0.4.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }
  

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.subnet.id
         }


  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "NPE"
  }
  depends_on = [
    azurerm_subnet.subnet,
    azurerm_resource_group.rg
  ]
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.firstaks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.firstaks.kube_config_raw

  sensitive = true
}


resource "azurerm_container_registry" "acr" {
  name                = "aksacrfordhp"
  location            = var.region
  resource_group_name = var.resourcegroup
  sku                 = "Premium"
}

resource "azurerm_role_assignment" "acr-rbac" {
  principal_id                     = azurerm_kubernetes_cluster.firstaks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}