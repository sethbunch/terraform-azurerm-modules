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

module "network" {
    source = "./modules/azure-network"
    name_prefix = "dev"
    location = "eastus2"
    vnet_cidr = "10.0.0.0/16"
    subnet_cidr = "10.0.1.0/24"
}