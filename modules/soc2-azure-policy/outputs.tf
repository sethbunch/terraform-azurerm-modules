output "region_policy_id" {
  description = "ID of the region_policy"
  value       = azurerm_policy_definition.region_policy.id
}

output "region_policy_assignment_id" {
  description = "ID of the region-policy assignment"
  value       = azurerm_subscription_policy_assignment.region_policy.id
}

output "required_tags_id" {
  description = "ID of the required-tags"
  value       = azurerm_policy_definition.required_tags.id
}

output "required_tags_assignment_id" {
  description = "ID of the required-tags assignment"
  value       = azurerm_subscription_policy_assignment.required_tags.id
}

output "public_storage_id" {
  description = "ID of the public-storage"
  value       = azurerm_policy_definition.public_storage.id
}

output "public_storage_assignment_id" {
  description = "ID of the public-storage assignment"
  value       = azurerm_subscription_policy_assignment.public_storage.id
}