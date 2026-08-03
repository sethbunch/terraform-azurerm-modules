output "storage_account_id" {
  description = "ID of the storage account holding Activity Logs"
  value       = azurerm_storage_account.log_storage.id
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.id
}

output "storage_account_name" {
  description = "Name of the storage account (for auditor verification)"
  value       = azurerm_storage_account.log_storage.name
}

output "log_analytics_workspace_customer_id" {
  description = "Customer ID of the Log Analytics Workspace (used by monitoring agents)"
  value       = azurerm_log_analytics_workspace.log_analytics.workspace_id
}