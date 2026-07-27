resource "azurerm_resource_group" "network" {
    name = "${var.name_prefix}-rg"
    location = var.location
    tags = var.tags
}

resource "azurerm_virtual_network" "main" {
    name = "${var.name_prefix}-vnet"
    location = var.location
    address_space = [var.vnet_cidr]
    resource_group_name = azurerm_resource_group.network.name
    tags = var.tags
}

resource "azurerm_subnet" "app" {
    name = "${var.name_prefix}-app-subnet"
    resource_group_name = azurerm_resource_group.network.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes = [var.app_subnet_cidr]
}

resource "azurerm_subnet" "data" {
    name = "${var.name_prefix}-data-subnet"
    resource_group_name = azurerm_resource_group.network.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes = [var.data_subnet_cidr]
}

resource "azurerm_network_security_group" "secgroup" {
    name = "${var.name_prefix}-nsg"
    location = var.location
    resource_group_name = azurerm_resource_group.network.name
    tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "app" {
    subnet_id = azurerm_subnet.app.id
    network_security_group_id = azurerm_network_security_group.secgroup.id
}

