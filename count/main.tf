terraform {
  required_version = ">= 0.13.0"
}

provider "azurerm" {
  version = "~>2.23.0"
  features {}
}

resource "azurerm_resource_group" "rg" {
  # Create 3 resource groups
  count    = 3
  name     = "buildagents-${count.index}-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "storage_account" {
  # Create 3 storage accounts
  count                    = 3
  name                     = "countstorage${count.index}"
  # Get the item from the list of resource groups that matches the current index
  resource_group_name      = azurerm_resource_group.rg.*.name[count.index]
  location                 = azurerm_resource_group.rg.*.location[count.index]
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
