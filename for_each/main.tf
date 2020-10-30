terraform {
  required_version = ">= 0.13.0"
}

locals {
    config = {
        tf = {
            replication_type = "ZRS"
            tier = "Standard"
            rg = azurerm_resource_group.rg[0]
        },
        fa = {
            replication_type = "LRS"
            tier = "Standard"
            rg = azurerm_resource_group.rg[1]
        }
    }
}

provider "azurerm" {
  version = "~>2.23.0"
  features {}
}

resource "azurerm_resource_group" "rg" {
  # Create 3 resource groups
  count = 2
  name     = "buildagents-${count.index}-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "storage_account" {
  # Create 3 storage accounts
  for_each                 = local.config
  # Use the key of the map to create the name
  name                     = "countstorage${each.key}"
  # Use each property in the map
  resource_group_name      = each.value.rg.name
  location                 = each.value.rg.location
  account_tier             = each.value.tier
  account_replication_type = each.value.replication_type
}