variable "rg_location" {
    description = "The location/region where the resource group will be created."
    type = string
}

variable "rg_name" {
    description = "The name of the resource group."
    type = string
}

variable "prefix" {
    description = "The prefix to use for all resources in this example."
    type = string
    default = "vm-iis"
}

variable "env" {
    description = "The environment for this example."
    type = string
}