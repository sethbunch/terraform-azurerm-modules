data "azurerm_client_config" "current" {}

resource "azurerm_security_center_automation" "auto_sec" {
  name                = "${var.name_prefix}-securescore-export"
  resource_group_name = var.resource_group_name
  location            = var.location

  action {
    type        = "Workspace"
    resource_id = var.log_analytics_workspace_id
  }

  scopes = ["/subscriptions/${data.azurerm_client_config.current.subscription_id}"]

  dynamic "source" {
    for_each = toset(var.event_sources)
    content {
      event_source = source.value
    }
  }

  enabled = var.automation_enabled

  tags = var.tags
}

resource "azurerm_application_insights_workbook" "workbook_insight" {
  name                = lower(uuidv5("dns", "${var.name_prefix}-soc2-workbook"))
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = "SOC 2 Compliance Overview"

  source_id = "azure monitor"
  category  = "workbook"

  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type = 1 # 1 = text tile
        content = {
          json = "# SOC 2 Compliance Overview\n\nThis workbook surfaces the secure score and regulatory compliance data that this module's Defender for Cloud continuous export streams into Log Analytics.\n\nExported data lands in the `SecureScore`, `SecureScoreControl`, and `RegulatoryComplianceAssessment` tables."
        }
      },
      {
        type = 1
        content = {
          json = "## SOC 2 Criteria Covered\n\n| Criteria | How this module helps |\n|---|---|\n| CC7.1 — Detect anomalies | Continuous export flags drifting controls as they happen |\n| CC7.2 — Monitor | Secure score + compliance % trended over time |\n| CC7.4 — Incident response | Assessment events land in the same workspace as the logs |\n\n*Deployed by Terraform module: soc2-secure-score*"
        }
      }
    ]
    isLocked            = false
    fallbackResourceIds = ["Azure Monitor"]
  })

  tags = var.tags
}

resource "azurerm_portal_dashboard" "comp_dashboard" {
  name                = "${var.name_prefix}-compliance-dashboard"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  dashboard_properties = <<DASH
{
  "lenses": {
    "0": {
      "order": 0,
      "parts": {
        "0": {
          "position": { "x": 0, "y": 0, "rowSpan": 2, "colSpan": 6 },
          "metadata": {
            "inputs": [],
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "title": "SOC 2 Compliance",
                  "subtitle": "Defender for Cloud posture",
                  "content": "Continuous export streams secure scores and regulatory compliance assessments into Log Analytics. Open the **SOC 2 Compliance Overview** workbook (Azure Monitor > Workbooks) for the full view."
                }
              }
            }
          }
        },
        "1": {
          "position": { "x": 6, "y": 0, "rowSpan": 2, "colSpan": 6 },
          "metadata": {
            "inputs": [],
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "title": "KQL quick check",
                  "subtitle": "",
                  "content": "Once export has run (~30 min), query in Log Analytics:\n\nSecureScore | take 10\n\nSecureScoreControl | take 10"
                }
              }
            }
          }
        }
      }
    }
  }
}
DASH
}

