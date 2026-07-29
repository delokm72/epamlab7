resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                             = var.storage_account_name
  account_tier                     = "Standard"
  account_replication_type         = "LRS"
  location                         = var.location
  resource_group_name              = azurerm_resource_group.rg.name
  allow_nested_items_to_be_public  = true
  cross_tenant_replication_enabled = false
  network_rules {
    default_action = "Allow"
  }
}

resource "azurerm_storage_container" "container" {
  # no need for variables as internal project
  name                  = "mycontainer"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "blob" {
  # no need for variables as internal project
  name                   = "blob_name"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/blob.txt"
}

module "cdn" {
  source   = "./modules/cdn"
  location = var.location
  # do not send var because with dependent value terra wait for rg created!
  # do not send var because with dependent value terra wait for rg created!
  resource_group_name = azurerm_resource_group.rg.name
  profile_name        = local.frontdoor_profile_name
  endpoint_name       = local.endpoint_name
  origin_group_name   = local.origin_group_name
  origin_name         = local.origin_name
  blob_hostname       = azurerm_storage_account.sa.primary_blob_host
}