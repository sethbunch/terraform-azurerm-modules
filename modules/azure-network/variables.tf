variable "name_prefix" {
    description = "The name of the prefix."
    type = string
}

variable "location" {
    description = "The specifiedlocation of the resource."
    type = string
    default = "eastus2"
}

variable "vnet_cidr" {
    description = "The CIDR block for the virtual network."
    type = string
}

variable "subnet_cidr" {
    description = "The CIDR block for the subnet."
    type = string
}