resource "azurerm_security_center_subscription_pricing" "microsoft_defender" {
  for_each      = toset(var.defender_plan_resource_types)
  tier          = "Standard"
  resource_type = each.value
}

resource "azurerm_security_center_contact" "vuln_contact" {
  name  = "security-alerts"
  email = var.security_contact_email
  phone = var.security_contact_phone

  alert_notifications = true
  alerts_to_admins    = true
}

resource "azurerm_security_center_setting" "mde_integration" {
  setting_name = "WDATP"
  enabled      = true
}

resource "azurerm_security_center_server_vulnerability_assessments_setting" "mde_setting" {
  vulnerability_assessment_provider = "MdeTvm"
}