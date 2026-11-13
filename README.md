# terraform-azurerm-modules

Portfolio of reusable Terraform modules for Azure, focused on **GRC compliance infrastructure**. Controls are mapped across three frameworks — SOC 2, ISO 27001:2022, and NIST 800-53 Rev 5 — so one environment supports multi-framework audits.

Each module is self-contained, variable-driven, and maps its deployed controls to specific SOC 2 trust service criteria with ISO 27001 Annex A and NIST 800-53 equivalents. Deploy individually or compose them in a root module for a full compliance-ready landing zone.

> **Scope note:** this repo deploys *preventive infrastructure* — guardrails, logging, and posture export. It is not a scanner and performs no audit logic. Control mappings document intent coverage across frameworks; they are not a certification claim.

## How the modules fit together

The modules form a pipeline, not just a list:

1. **Detect & collect** — `soc2-activity-log` creates the Log Analytics workspace every later module writes into
2. **Prevent** — `soc2-azure-policy` (deny non-compliant deployments) and `soc2-defender-for-cloud` (threat protection + vulnerability scanning)
3. **Prove** — `soc2-secure-score` continuously exports secure scores and regulatory compliance assessments into the same workspace and visualizes them — evidence the controls from steps 1–2 are actually working
4. **Govern identity** *(in progress)* — `soc2-entra-id` brings the front door under code: conditional access, MFA baseline, PIM-style role eligibility

New to the repo? Read modules in that order — each one's README assumes the previous.

## Modules

| Module | Description | SOC 2 | ISO 27001:2022 | NIST 800-53 R5 | Status |
|--------|-------------|-------|----------------|----------------|--------|
| [azure-network](modules/azure-network/) | Resource Group, VNet, subnets, NSG | CC6.1 | A.8.20, A.8.22 | SC-7 | ✅ Complete |
| [soc2-activity-log](modules/soc2-activity-log/) | Activity Log diagnostics, Log Analytics, optional Event Hub streaming | CC7.2 | A.8.15 | AU-2, AU-4 | ✅ Complete |
| [soc2-azure-policy](modules/soc2-azure-policy/) | Azure Policy definitions + assignments (allowed regions, required tags, block public storage) | CC6.1, CC6.6, CC7.1 | A.8.9 | CM-2, AC-3 | ✅ Complete |
| [soc2-defender-for-cloud](modules/soc2-defender-for-cloud/) | Microsoft Defender for Cloud enablement, security contact, MDE integration, vulnerability scanning | CC7.1, CC7.2 | A.8.16 | RA-5, SI-2 | ✅ Complete |
| [soc2-secure-score](modules/soc2-secure-score/) | Defender continuous export (secure scores, regulatory compliance) → Log Analytics, Azure Workbook, Portal dashboard | CC7.1, CC7.2, CC7.4 | A.5.35, A.8.16 | CA-7 | ✅ Complete |

### Planned

| Module | Description | SOC 2 | ISO 27001:2022 | NIST 800-53 R5 |
|--------|-------------|-------|----------------|----------------|
| soc2-entra-id | Entra ID governance, PIM, Conditional Access | CC6.1, CC6.2 | A.5.15–A.5.18 | AC-2, AC-6, IA-2 |
| soc2-key-vault | Key Vault, managed HSM, key rotation | CC6.1, CC6.7 | A.8.24 | SC-12, SC-28 |
| soc2-storage | Blob encryption, soft delete, immutability | CC6.1, CC6.6 | A.8.24, A.8.13 | SC-28, CP-9 |
| soc2-sql-database | TDE, auditing, vulnerability assessment | CC6.1, CC6.7 | A.8.24, A.8.15 | SC-28, AU-2 |
| soc2-vnet | NSGs, private subnets, flow logs, Azure Firewall | CC6.1, CC6.6 | A.8.20–A.8.22 | SC-7, SC-10 |
| soc2-backup | Backup vault, policies, immutable storage | CC7.3 | A.8.13 | CP-9, CP-10 |
| soc2-sentinel | Sentinel workspace, analytics rules | CC7.1, CC7.2 | A.5.25, A.8.16 | IR-4, AU-6 |
| graph-audit-script | Python + Microsoft Graph: stale accounts, MFA gaps, orphaned app registrations → JSON/CSV report | CC6.2, CC6.3 | A.5.18, A.8.9 | AC-2, IA-2(1) |

## Architecture

```
Root Module (main.tf)
├── module "network_dev"      → azure-network (dev environment)
├── module "network_prod"     → azure-network (prod environment)
├── module "activity_log"     → soc2-activity-log (subscription-level logging)
├── module "azure_policy"     → soc2-azure-policy (subscription-level policies)
├── module "defender_cloud"   → soc2-defender-for-cloud (subscription-level threat protection)
└── module "secure_score"     → soc2-secure-score (posture export + compliance visibility)
```

## Provider

- **azurerm** `~> 4.0`

## Usage

```hcl
module "network_dev" {
  source           = "./modules/azure-network"
  name_prefix      = "dev"
  location         = "eastus2"
  vnet_cidr        = "10.0.0.0/16"
  app_subnet_cidr  = "10.0.1.0/24"
  data_subnet_cidr = "10.0.2.0/24"
  tags = {
    Environment = "dev"
    Owner       = "SB"
  }
}
```

## Deployment

```bash
terraform init
terraform plan
terraform apply
```

## Tech Stack

- Terraform ≥ 1.0
- Azure Provider (azurerm) ~> 4.0
- Azure for Students subscription
- Azure regions: eastus2, westus, southcentralus, northcentralus, mexicocentral
