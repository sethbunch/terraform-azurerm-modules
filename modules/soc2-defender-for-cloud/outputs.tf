output "defender_pricing_ids" {
  description = "ID of the Microsoft Defender subscription"
  value       = [for k, v in azurerm_security_center_subscription_pricing.microsoft_defender : v.id]
}

output "security_contact_id" {
  description = "ID of the security alert contact"
  value       = azurerm_security_center_contact.vuln_contact.id
}

output "defender_endpoint_setting_id" {
  description = "ID of the MDE setting"
  value       = azurerm_security_center_setting.mde_integration.id
}

output "vuln_assessment_setting_id" {
  description = "ID of the vulnerability assessment setting"
  value       = azurerm_security_center_server_vulnerability_assessments_setting.mde_setting.id
}