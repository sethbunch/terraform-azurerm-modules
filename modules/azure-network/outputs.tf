output "resource_group_name" {
    value = azurerm_resource_group.network.name
}

output "vnet_id" {
    value = azurerm_virtual_network.main.id
}

output "subnet_id" {
    value = azurerm_subnet.app.id
}