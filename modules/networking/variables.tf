
variable "env" {
  type        = string
  description = "Environment for naming resources"
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
}

variable "rg_location" {
  type        = string
  description = "Location for the resources"
}

variable "rg_name" {
  type        = string
  description = "Name of the resource group"
}

variable "is_prod_environment" {
  type        = bool
  default     = false
  description = "Is this a production environment?"
}

variable "subnets" {
  default = {
    private = {
      address_prefix = "10.0.1.0/24"
    }
    public = {
      address_prefix = "10.0.2.0/24"
    }
  }
}

variable "prefix" {
  description = "Prefix for all resources"
  type = string
  default = "linux-vm-iis"
}