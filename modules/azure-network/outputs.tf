output "resource_group_name" {
  description = "ID of the resource group used"
  value       = azurerm_resource_group.network.name
}

output "vnet_id" {
  description = "ID of the vnet"
  value       = azurerm_virtual_network.main.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = azurerm_subnet.app.id
}