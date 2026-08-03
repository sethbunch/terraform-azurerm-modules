# soc2-azure-policy

Azure Policy module — deploys three custom policy definitions with subscription-level assignments to enforce compliance guardrails.

## Policies

| Policy | Effect | Description |
|--------|--------|-------------|
| **Allowed Regions** | Deny | Blocks resource creation outside approved Azure regions |
| **Required Tags** | Deny | Blocks resource creation if `Environment` or `Owner` tags are missing |
| **Block Public Storage** | Deny | Blocks storage accounts with public blob access enabled |

## Resources

| Resource | Name | Description |
|----------|------|-------------|
| `azurerm_policy_definition` | `.region_policy` | Custom policy: allowed regions |
| `azurerm_subscription_policy_assignment` | `.region_policy` | Assignment at subscription scope |
| `azurerm_policy_definition` | `.required_tags` | Custom policy: required tags |
| `azurerm_subscription_policy_assignment` | `.required_tags` | Assignment at subscription scope |
| `azurerm_policy_definition` | `.public_storage` | Custom policy: block public storage |
| `azurerm_subscription_policy_assignment` | `.public_storage` | Assignment at subscription scope |

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name_prefix` | `string` | — | Prefix for all policy names |
| `allowed_locations` | `list(string)` | — | List of approved Azure regions |
| `required_tags` | `list(string)` | — | Tags required on all resources |
| `tags` | `map(string)` | `{compliance = "soc2"}` | Compliance tags |

## Outputs

| Name | Description |
|------|-------------|
| `region_policy_id` | ID of the allowed regions policy definition |
| `region_policy_assignment_id` | ID of the allowed regions assignment |
| `required_tags_id` | ID of the required tags policy definition |
| `required_tags_assignment_id` | ID of the required tags assignment |
| `public_storage_id` | ID of the public storage policy definition |
| `public_storage_assignment_id` | ID of the public storage assignment |

## Usage

```hcl
module "azure_policy" {
  source            = "./modules/soc2-azure-policy"
  name_prefix       = "soc2policy"
  allowed_locations = ["eastus2"]
  required_tags     = ["Environment", "Owner"]
  tags = {
    Environment = "lab"
    Owner       = "Terraform"
  }
}
```

## SOC 2 Mapping

- **CC6.1** — Allowed regions policy restricts data residency to approved geographies, supporting logical access and data location controls.
- **CC6.6** — Required tags policy enforces resource ownership and environment labeling, enabling accountability and access reviews.
- **CC7.1** — Public storage block policy prevents accidental exposure of sensitive data, supporting system boundary protection.
