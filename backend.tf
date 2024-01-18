
    terraform {
      backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstate1044118378"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
      access_key           = "tYdd+HqQ5RSE1gAxyH2HpAl0gt31cjE2vH5LbjbK1n0m827mYlPUagvP2Q/Rv9jlYlY3pDRCz8oh+AStU3PZ+w=="
    }
    }