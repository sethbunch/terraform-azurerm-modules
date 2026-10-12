# terraform-azurerm-modules

Portfolio of reusable Terraform modules for Azure, focused on **GRC and SOC 2 compliance infrastructure**.

Each module is self-contained, variable-driven, and maps to specific SOC 2 trust service criteria. Deploy individually or compose them in a root module for a full compliance-ready landing zone.

## Modules

| Module | Description | SOC 2 Criteria | Status |
|--------|-------------|----------------|--------|
| [azure-network](modules/azure-network/) | Resource Group, VNet, subnets, NSG | CC6.1 (Network Security) | ✅ Complete |
| [soc2-activity-log](modules/soc2-activity-log/) | Activity Log diagnostics, Log Analytics, optional Event Hub streaming | CC7.2 (System Monitoring) | ✅ Complete |
| [soc2-azure-policy](modules/soc2-azure-policy/) | Azure Policy definitions + assignments (allowed regions, required tags, block public storage) | CC6.1, CC6.6, CC7.1 | ✅ Complete |
| [soc2-defender-for-cloud](modules/soc2-defender-for-cloud/) | Microsoft Defender for Cloud enablement, security contact, MDE integration, vulnerability scanning | CC7.1, CC7.2 | ✅ Complete |
| [soc2-secure-score](modules/soc2-secure-score/) | Defender continuous export (secure scores, regulatory compliance) → Log Analytics, Azure Workbook, Portal dashboard | CC7.1, CC7.2, CC7.4 | ✅ Complete |

### Planned

| Module | Description | SOC 2 Criteria |
|--------|-------------|----------------|
| soc2-entra-id | Entra ID governance, PIM, Conditional Access | CC6.1, CC6.2 |
| soc2-key-vault | Key Vault, managed HSM, key rotation | CC6.1, CC6.7 |
| soc2-storage | Blob encryption, soft delete, immutability | CC6.1, CC6.6 |
| soc2-sql-database | TDE, auditing, vulnerability assessment | CC6.1, CC6.7 |
| soc2-vnet | NSGs, private subnets, flow logs, Azure Firewall | CC6.1, CC6.6 |
| soc2-backup | Backup vault, policies, immutable storage | CC7.3 (Availability) |
| soc2-sentinel | Sentinel workspace, analytics rules | CC7.1, CC7.2 |

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
