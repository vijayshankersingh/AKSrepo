
resource "azurerm_resource_group" "rg" {
  name     = var.resourcegroup
  location = var.region
  tags = {
    Environment = "Terraform Getting Started"
    Team = "DevOps"
  }
}


