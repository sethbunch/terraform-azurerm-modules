terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~>4.0"
        }
    }
}

provider "azurerm" {
    features {}
}

module "network_dev" {
    source = "./modules/azure-network"
    name_prefix = "dev"
    location = "eastus2"
    vnet_cidr = "10.0.0.0/16"
    app_subnet_cidr = "10.0.1.0/24"
    data_subnet_cidr = "10.0.2.0/24"

    tags = {
        Environment = "dev"
        Owner = "SB"
        DataClassification = "Confidential"
    }
}
 module "network_prod" {
    source = "./modules/azure-network"
    name_prefix = "prod"
    location = "eastus2"
    vnet_cidr = "10.1.0.0/16"
    app_subnet_cidr = "10.1.1.0/24"
    data_subnet_cidr = "10.1.2.0/24"

    tags = {
        Environment = "prod"
        Owner = "SB"
        DataClassification = "Confidential"
    }
 }
