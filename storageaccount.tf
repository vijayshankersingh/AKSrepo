
resource "azurerm_storage_account" "azstorage" {
  name                     = "teststoragestore"
  resource_group_name      = var.resourcegroup
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}
resource "azurerm_storage_container" "terraform" {
  name                  = "test-store"
  storage_account_name  = azurerm_storage_account.azstorage.name
  container_access_type = "blob"
  depends_on = [
    azurerm_storage_account.azstorage
  ]
  }
  resource "azurerm_storage_blob" "terraform" {
  name                   = "terraform-file"
  storage_account_name   = azurerm_storage_account.azstorage.name
  storage_container_name = azurerm_storage_container.terraform.name
  type                   = "Block"
  source                 = "main.tf"
  depends_on = [
    azurerm_storage_container.terraform
  ]
  }
     