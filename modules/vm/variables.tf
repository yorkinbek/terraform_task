
variable "env" {
  description = "Environment"
  type = string
}

variable rg_name {
  type        = string
}

variable rg_location {
  type        = string
}

variable "vm_name" {
  type        = string
  description = "The name of the virtual machine that will be created."
}

variable "vm_size" {
  type        = string
  description = "The size of the virtual machine."
}

variable "admin_username" {
  type        = string
  description = "The username of the local administrator to be created."
  default     = "adminuser"
}

variable "computer_name" {
  type        = string
  description = "The name of the virtual machine that will be created."
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account that will be created."
}

variable "os_disk" {
  description = "OS disk configuration"
  type = object({
    name                 = string
    caching              = string
    storage_account_type = string
  })
  
}

variable "admin_ssh_key" {
  description = "SSH key for admin user"
  type = object({
    username = string
    public_key = string
  })
}


variable "ip_configuration" {
  description = "IP configuration"
  type = object({
    name                            = string
    subnet_id                       = string
    private_ip_address_allocation   = string
    public_ip_address_id            = string
  })
}

variable "prefix" {
  description = "Prefix for all resources"
  type = string
  default = "linux-vm-iis"
}
