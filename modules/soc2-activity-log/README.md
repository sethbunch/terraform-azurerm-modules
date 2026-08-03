# soc2-activity-log

Centralized logging module — deploys Activity Log diagnostic settings, a Log Analytics Workspace, a Storage Account for long-term log retention, and an optional Event Hub for SIEM streaming.

## Resources

| Resource | Name | Description |
|----------|------|-------------|
| `azurerm_resource_group` | `.activity_log` | Dedicated RG for logging resources |
| `azurerm_storage_account` | `.log_storage` | Immutable log storage (LRS, TLS 1.2, HTTPS only) |
| `azurerm_log_analytics_workspace` | `.log_analytics` | Log Analytics Workspace with configurable retention |
| `azurerm_eventhub_namespace` | `.log_stream` | Event Hub namespace (optional, for SIEM streaming) |
| `azurerm_eventhub` | `.log_stream` | Event Hub for log streaming (optional) |
| `azurerm_eventhub_authorization_rule` | `.log_stream` | Send-only auth rule for Event Hub (optional) |
| `azurerm_monitor_diagnostic_setting` | `.log-ds` | Subscription-level diagnostic setting |

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name_prefix` | `string` | — | Prefix for all resource names |
| `location` | `string` | `"eastus2"` | Azure region (validated) |
| `retention_days` | `number` | `90` | Log retention (30–3650 days, validated) |
| `enable_event_hub` | `bool` | `false` | Enable Event Hub for SIEM streaming |
| `log_categories` | `list(string)` | `["allLogs"]` | Log category groups to capture |
| `tags` | `map(string)` | `{compliance = "soc2"}` | Compliance tags |

## Outputs

| Name | Description |
|------|-------------|
| `storage_account_id` | ID of the log storage account |
| `log_analytics_workspace_id` | ID of the Log Analytics Workspace |
| `storage_account_name` | Name of the storage account (for auditor verification) |
| `log_analytics_workspace_customer_id` | Customer ID for monitoring agents |

## Usage

```hcl
module "activity_log" {
  source           = "./modules/soc2-activity-log"
  name_prefix      = "soc2lab"
  location         = "eastus2"
  retention_days   = 90
  enable_event_hub = false
  tags = {
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}
```

## SOC 2 Mapping

**CC7.2** — The entity monitors system components and the operation of those components for anomalies. Subscription-level Activity Logs are captured to both a Storage Account (long-term immutable retention) and a Log Analytics Workspace (queryable by auditors). Optional Event Hub enables streaming to external SIEM platforms.
