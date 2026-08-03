# terraform-azurerm-modules

Portfolio of reusable Terraform modules for Azure, focused on **GRC and SOC 2 compliance infrastructure**.

Each module is self-contained, variable-driven, and maps to specific SOC 2 trust service criteria. Deploy individually or compose them in a root module for a full compliance-ready landing zone.

## Modules

| Module | Description | SOC 2 Criteria | Status |
|--------|-------------|----------------|--------|
| [azure-network](modules/azure-network/) | Resource Group, VNet, subnets, NSG | CC6.1 (Network Security) | ✅ Complete |
| [soc2-activity-log](modules/soc2-activity-log/) | Activity Log diagnostics, Log Analytics, optional Event Hub streaming | CC7.2 (System Monitoring) | ✅ Complete |
| [soc2-azure-policy](modules/soc2-azure-policy/) | Azure Policy definitions + assignments (allowed regions, required tags, block public storage) | CC6.1, CC6.6, CC7.1 | ✅ Complete |

### Planned

| Module | Description | SOC 2 Criteria |
|--------|-------------|----------------|
| soc2-key-vault | Managed identities, Key Vault, secrets management | CC6.1, CC6.7 |
| soc2-rbac | Role-based access control assignments, PIM-ready roles | CC6.1, CC6.2 |
| soc2-backup | Backup vaults, retention policies, periodic snapshots | CC7.3 (Availability) |
| soc2-network-security | NSG rules, DDoS protection, Private Endpoints | CC6.1, CC6.6 |

## Architecture

```
Root Module (main.tf)
├── module "network_dev"     → azure-network (dev environment)
├── module "network_prod"    → azure-network (prod environment)
├── module "activity_log"    → soc2-activity-log (subscription-level logging)
└── module "azure_policy"    → soc2-azure-policy (subscription-level policies)
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
