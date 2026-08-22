resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "terraform-state"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = false
  shared_access_key_enabled        = true
  public_network_access_enabled    = true

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Environment = "terraform-state"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "tfstate_blob_contributor" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}