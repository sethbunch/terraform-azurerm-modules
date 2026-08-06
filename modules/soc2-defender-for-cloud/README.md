# soc2-defender-for-cloud

Enables Microsoft Defender for Cloud across an Azure subscription with security alert routing, MDE integration, and vulnerability scanning.

## Resources

| Resource | Description |
|----------|-------------|
| `azurerm_security_center_subscription_pricing` | Enables Defender Standard tier per resource type (CloudPosture, VirtualMachines, StorageAccounts, etc.) |
| `azurerm_security_center_contact` | Security contact for alert notifications (email + phone), with admin alerts enabled |
| `azurerm_security_center_setting` | Microsoft Defender for Endpoint (MDE) integration |
| `azurerm_security_center_server_vulnerability_assessment_setting` | Agentless VM vulnerability scanning via MdeTvm |

## SOC 2 Mapping

- **CC7.1** — System Monitoring: Defender provides continuous threat detection across enabled resource types
- **CC7.2** — Detection and Monitoring: Security alerts routed to designated contacts, vulnerability assessments run automatically

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `name_prefix` | Prefix for resource naming | `string` | Yes |
| `security_contact_email` | Email for alert notifications | `string` | Yes |
| `security_contact_phone` | Phone for alert notifications | `string` | Yes |
| `defender_plan_resource_types` | Defender plans to enable (e.g. `["CloudPosture", "VirtualMachines", "StorageAccounts"]`) | `list(string)` | Yes |
| `enable_vm_vuln_scan` | Toggle agentless VM vulnerability scanning | `bool` | No (default: `true`) |
| `enable_defender_for_endpoint` | Toggle MDE integration | `bool` | No (default: `true`) |
| `tags` | Compliance tags applied to resources | `map(string)` | No (default: `{"Compliance" = "soc2"}`) |

## Outputs

| Name | Description |
|------|-------------|
| `defender_pricing_ids` | IDs of the Defender subscription pricing configurations |
| `security_contact_id` | ID of the security alert contact |
| `defender_endpoint_setting_id` | ID of the MDE integration setting |
| `vuln_assessment_setting_id` | ID of the vulnerability assessment setting |

## Usage

```hcl
module "defender_cloud" {
  source                       = "./modules/soc2-defender-for-cloud"
  name_prefix                  = "soc2def"
  security_contact_email       = var.security_contact_email
  security_contact_phone       = var.security_contact_phone
  defender_plan_resource_types = ["CloudPosture", "VirtualMachines", "StorageAccounts"]
}
```
