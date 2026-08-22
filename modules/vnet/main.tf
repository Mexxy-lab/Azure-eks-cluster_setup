resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  address_space = var.vnet_address_space

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_subnet" "public" {
  name                 = var.public_subnet_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_cidr]
}

resource "azurerm_subnet" "private" {
  name                 = var.private_subnet_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_cidr]
}