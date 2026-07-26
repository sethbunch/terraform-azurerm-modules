resource "azurerm_resource_group" "network" {
    name = "${var.name_prefix}-rg"
    location = var.location
}

resource "azurerm_virtual_network" "main" {
    name = "${var.name_prefix}-vnet"
    location = var.location
    address_space = [var.vnet_cidr]
    resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_subnet" "app" {
    name = "${var.name_prefix}-subnet"
    resource_group_name = azurerm_resource_group.network.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes = [var.subnet_cidr]
}