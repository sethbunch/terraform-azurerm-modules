data "azurerm_subscription" "current" {}

resource "azurerm_policy_definition" "region_policy" {
  name         = "${var.name_prefix}-allowed-regions"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed regions - SOC2 Compliance"

  policy_rule = <<POLICY_RULE
 {
    "if": {
      "not": {
        "field": "location",
        "in": "[parameters('allowedLocations')]"
      }
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE

  parameters = <<PARAMETERS
 {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed regions for resources.",
        "displayName": "Allowed Regions",
        "strongType": "location"
      }
    }
  }
PARAMETERS
}

resource "azurerm_subscription_policy_assignment" "region_policy" {
  name                 = "${var.name_prefix}-allowed-regions-assignment"
  policy_definition_id = azurerm_policy_definition.region_policy.id
  subscription_id      = data.azurerm_subscription.current.id
  display_name         = "Allowed Regions - SOC2"
  parameters = jsonencode({
    allowedLocations = { value = var.allowed_locations }
  })
}

resource "azurerm_policy_definition" "required_tags" {
  name         = "${var.name_prefix}-required-tags"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Required Tags - SOC2 Compliance"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        for tag in var.required_tags : {
          field  = "tags[${tag}]"
          exists = "false"
        }
      ]
    }
    then = {
      effect = "Deny"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "required_tags" {
  name                 = "${var.name_prefix}-required-tags-assignment"
  policy_definition_id = azurerm_policy_definition.required_tags.id
  subscription_id      = data.azurerm_subscription.current.id
  display_name         = "Required Tags - SOC2"
}

resource "azurerm_policy_definition" "public_storage" {
  name         = "${var.name_prefix}-public-storage"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Block Public Storage Access - SOC2"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Storage/storageAccounts"
        },
        {
          field  = "Microsoft.Storage/storageAccounts/allowBlobPublicAccess"
          equals = true
        }
      ]
    }
    then = {
      effect = "Deny"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "public_storage" {
  name                 = "${var.name_prefix}-public-storage-assignment"
  policy_definition_id = azurerm_policy_definition.public_storage.id
  subscription_id      = data.azurerm_subscription.current.id
  display_name         = "Block Public Storage Access - SOC2"
}
