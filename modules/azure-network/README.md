# azure-network

Foundational networking module — creates a Resource Group, Virtual Network, two subnets (app + data), and a Network Security Group.

## Resources

| Resource | Name | Description |
|----------|------|-------------|
| `azurerm_resource_group` | `.network` | Resource group for all networking resources |
| `azurerm_virtual_network` | `.main` | VNet with configurable CIDR |
| `azurerm_subnet` | `.app` | Application subnet |
| `azurerm_subnet` | `.data` | Data subnet |
| `azurerm_network_security_group` | `.secgroup` | NSG attached to app subnet |
| `azurerm_subnet_network_security_group_association` | `.app` | Binds NSG to app subnet |

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name_prefix` | `string` | — | Prefix for all resource names |
| `location` | `string` | `"eastus2"` | Azure region (validated against 5 allowed regions) |
| `vnet_cidr` | `string` | — | CIDR block for the VNet |
| `app_subnet_cidr` | `string` | — | CIDR block for the app subnet |
| `data_subnet_cidr` | `string` | — | CIDR block for the data subnet |
| `tags` | `map(string)` | — | Tags applied to all resources |

## Outputs

| Name | Description |
|------|-------------|
| `resource_group_name` | Name of the resource group |
| `vnet_id` | ID of the virtual network |
| `subnet_id` | ID of the app subnet |

## Usage

```hcl
module "network" {
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

## SOC 2 Mapping

**CC6.1** — Logical and physical access controls. Network segmentation via subnets and NSGs restricts traffic between application and data tiers.
