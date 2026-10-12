output "secure_score_automation_id" {
  description = "Resource ID of the Defender for Cloud continuous export automation"
  value       = azurerm_security_center_automation.auto_sec.id
}

output "workbook_id" {
  description = "Resource ID of the SOC 2 compliance Azure Workbook"
  value       = azurerm_application_insights_workbook.workbook_insight.id
}

output "dashboard_id" {
  description = "Resource ID of the SOC 2 compliance portal dashboard"
  value       = azurerm_portal_dashboard.comp_dashboard.id
}

output "workbook_name" {
  description = "Generated GUID name of the SOC 2 workbook (not derivable from the prefix — needed by Sentinel wiring later)"
  value       = azurerm_application_insights_workbook.workbook_insight.name
}
