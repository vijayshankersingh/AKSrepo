
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "akv" {
  for_each=toset(["dhp", "edp","mlp"])  
  name                        = "akvfor${each.key}"
  location                    = var.region
  resource_group_name         = var.resourcegroup
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]

    storage_permissions = [
      "Get",
    ]
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}
resource "azurerm_key_vault_secret" "akv" {
  for_each=toset(["dhp", "edp","mlp"])  
  name         = "secret-sa-${each.key}"
  value        = var.secret
  key_vault_id = azurerm_key_vault.akv[each.key].id
  depends_on = [
    azurerm_key_vault.akv
  ]
}
/*
resource "azurerm_key_vault_access_policy" "akvpolicy" {
  for_each=toset(["dhp", "edp","mlp"])  
  key_vault_id = azurerm_key_vault.akv[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  object_id    = var.userid

  key_permissions = [
    "Create",
    "Get",
    ]

  secret_permissions = [
    "Set",
    "List",
    "Get",
    "Delete",
    "Purge",
    "Recover"
    ]

  storage_permissions = [
    "Get",
    ]
  depends_on = [
    azurerm_key_vault.akv,
    azurerm_resource_group.rg
  ]
} */

/*data "azurerm_key_vault" "akv" {
  for_each=toset(["dhp", "edp","mlp"])  
  name                = "testkeyvault-${each.key}"
  resource_group_name = var.resourcegroup
  depends_on = [
    azurerm_key_vault.akv
  ]
}*/

/* 
/*output "vault_uri" {
  #for_each=var.project
  value = data.azurerm_key_vault.akv[each.key].vault_uri
} */
/*
 data "azurerm_key_vault_secret" "akv" {
  for_each=toset(["dhp", "edp","mlp"])  
  name         = "secret-sa-${each.key}"
 
  key_vault_id = data.azurerm_key_vault.akv[each.key].id
  depends_on = [
    azurerm_key_vault.akv
  ]
}
*/
/* 
output "secret_value" {

  value     = data.azurerm_key_vault_secret.akv[each.key].value
  sensitive = true
} 
*/