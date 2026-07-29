resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/6970fed9-7ce8-4507-abe0-0e1023b35f29/resourceGroups/cmtr-53z813ye-mod7-rg"
}

resource "azurerm_storage_account" "sa" {
  name                             = var.storage_account_name
  account_tier                     = "Standard"
  account_replication_type         = "LRS"
  location                         = var.location
  resource_group_name              = azurerm_resource_group.rg.name
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  #try for test
  network_rules {
    default_action = "Allow"
  }
}

import {
  to = azurerm_storage_account.sa
  id = "/subscriptions/6970fed9-7ce8-4507-abe0-0e1023b35f29/resourceGroups/cmtr-53z813ye-mod7-rg/providers/Microsoft.Storage/storageAccounts/cmtr53z813yemod7sa"
}

module "cdn" {
  source              = "./modules/cdn"
  location            = var.location
  resource_group_name = var.resource_group_name
  profile_name        = local.frontdoor_profile_name
  endpoint_name       = local.endpoint_name
  origin_group_name   = local.origin_group_name
  origin_name         = local.origin_name
  blob_hostname       = azurerm_storage_account.sa.primary_blob_host
}