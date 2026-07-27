variable "name_prefix" {
    description = "The name of the prefix."
    type = string
}

variable "location" {
    description = "The specifiedlocation of the resource."
    type = string
    default = "eastus2"
    validation {
        condition = contains(["eastus2", "westus", "southcentralus", "mexicocentral", "northcentralus"], var.location)
        error_message = "Location must be one of: eastus2, westus, southcentralus, mexicocentral, northcentralus."
    }
}

variable "vnet_cidr" {
    description = "The CIDR block for the virtual network."
    type = string
}

variable "app_subnet_cidr" {
    description = "The CIDR block for the subnet."
    type = string
}

variable "data_subnet_cidr" {
    description = "The CIDR block for the data subnet."
    type = string
}

variable "tags" {
    type = map(string)
    description = "Tags applied to all resources."
}