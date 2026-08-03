terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "network_dev" {
  source           = "./modules/azure-network"
  name_prefix      = "dev"
  location         = "eastus2"
  vnet_cidr        = "10.0.0.0/16"
  app_subnet_cidr  = "10.0.1.0/24"
  data_subnet_cidr = "10.0.2.0/24"

  tags = {
    Environment        = "dev"
    Owner              = "SB"
    DataClassification = "Confidential"
  }
}

module "network_prod" {
  source           = "./modules/azure-network"
  name_prefix      = "prod"
  location         = "eastus2"
  vnet_cidr        = "10.1.0.0/16"
  app_subnet_cidr  = "10.1.1.0/24"
  data_subnet_cidr = "10.1.2.0/24"

  tags = {
    Environment        = "prod"
    Owner              = "SB"
    DataClassification = "Confidential"
  }
}

module "activity_log" {
  source           = "./modules/soc2-activity-log"
  name_prefix      = "soc2lab"
  location         = "eastus2"
  retention_days   = 90
  enable_event_hub = false
  tags = {
    Environment        = "lab"
    ManagedBy          = "Terraform"
    DataClassification = "Confidential"
    Module             = "soc2-activity-log"
    compliance         = "soc2-CC7.2"
  }
}

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
