# soc2-secure-score

Exports Microsoft Defender for Cloud security posture (secure scores + regulatory compliance assessments) to Log Analytics and makes it visible through an Azure Workbook and a shared Portal dashboard. Modules 2 and 3 create the controls — this module proves they're working.

Terraform builds the pipeline, not the number: there is no data source to read a secure score, so the pattern is **export (automation) → store (Log Analytics) → visualize (workbook/dashboard)**.

## Resources

| Resource | Name | Description |
|----------|------|-------------|
| `azurerm_security_center_automation` | `auto_sec` | Continuous export of secure score / regulatory compliance events to a Log Analytics workspace. Subscription-scoped via `azurerm_client_config`; event sources are data-driven (`for_each` over `var.event_sources`) |
| `azurerm_application_insights_workbook` | `workbook_insight` | SOC 2 Compliance Overview workbook (text tiles: pipeline summary + criteria mapping). Name is a deterministic lowercase GUID via `uuidv5` |
| `azurerm_portal_dashboard` | `comp_dashboard` | Shared portal dashboard with compliance overview + KQL quick-check tiles |

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name_prefix` | `string` | — | Prefix for all resources |
| `resource_group_name` | `string` | — | Resource group for all three resources (accepts an existing RG, e.g. Module 1's) |
| `location` | `string` | `"eastus2"` | Azure region (validated against the 5 allowed lab regions) |
| `log_analytics_workspace_id` | `string` | — | Full resource ID of the destination workspace (Module 1 output) |
| `automation_enabled` | `bool` | `true` | Pause the export without destroying it |
| `event_sources` | `list(string)` | 3 snapshot sources | Defender export event types (validated against the 11 legal values) |
| `tags` | `map(string)` | `{Compliance = "soc2"}` | Standard compliance tags |

## Outputs

| Name | Description |
|------|-------------|
| `secure_score_automation_id` | Resource ID of the continuous export automation |
| `workbook_id` | Resource ID of the SOC 2 workbook |
| `dashboard_id` | Resource ID of the portal dashboard |
| `workbook_name` | Generated GUID name of the workbook (consumed by future Sentinel wiring — not derivable from the prefix) |

## Usage

```hcl
module "secure_score" {
  source                     = "./modules/soc2-secure-score"
  name_prefix                = "soc2secscore"
  resource_group_name        = module.activity_log.resource_group_name
  location                   = "eastus2"
  log_analytics_workspace_id = module.activity_log.log_analytics_workspace_id
}
```

## Verification & Timing (learned the hard way)

- **Snapshot event sources are WEEKLY, not "30 min"** — `SecureScoresSnapshot` etc. fire once per week per subscription, at an unknowable point in the cycle. `Failed to resolve table` on `SecureScore | count` for up to ~7 days after apply is NORMAL, not a bug.
- **Fast-path proof:** add a streaming source (`"Assessments"`) to `event_sources` at the ROOT call — streaming events land in `SecurityRecommendation` when an assessment changes state. Keep the module default snapshot-only: streaming is per-event ingestion, which costs real money at prod scale. (Caveat: events only fire on assessment *state changes* — a quiet subscription sends nothing until Defender recomputes.)
- **Verify without the portal:**
  ```bash
  az resource show --id <automation-id> --query "properties.sources[].eventSource" -o tsv
  az monitor log-analytics query -w <customerId> --analytics-query "SecureScore | count"
  ```
  Empty output = table doesn't exist yet · `Count: 0` = table exists, data pending · `Count > 0` = landed.
- **Policy gotcha:** updates to this automation are ARM PUTs — if a required-tags Deny policy (Module 2) is assigned, the call-site tags must include every required tag (`Owner` bit me: 403 RequestDisallowedByPolicy on a resource created before the policy landed). Policy enforcement working as designed.

## SOC 2 Mapping

**CC7.1** — Continuous export of SecureScoreControls flags drifting controls as they happen.
**CC7.2** — Secure score history + regulatory compliance % trended in a workbook.
**CC7.4** — Compliance assessment events land in the same workspace as the logs — one place to investigate.
