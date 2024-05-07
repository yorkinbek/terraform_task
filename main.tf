terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.75.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name   = "Resources-QA"
    storage_account_name  = "stforqa"
    container_name        = "statefiles-qa"
    key                   = "terrafrom.tfstate"
  }
}


provider "azurerm" {
  
    features {
        key_vault {
        purge_soft_delete_on_destroy    = true
        recover_soft_deleted_key_vaults = true
        }
    }
}


module "networking" {
  source = "./modules/networking"


  rg_name = var.rg_name[var.env]
  rg_location = var.rg_location
  address_space = ["10.0.0.0/16"]
  env = var.env
  is_prod_environment = var.env == "prod" ? true : false 

}


module "keyvault" {
  source = "./modules/keyvault"
  env = var.env
  rg_name = var.rg_name[var.env]
  rg_location = var.rg_location
  
}

module "vm-1" {
  source = "./modules/vm"
  env = var.env
  vm_name = "vm-1-${var.env}"
  rg_name = var.rg_name[var.env]
  rg_location = var.rg_location
  vm_size = "Standard_DS1_v2"
  computer_name = "vm-1-${var.env}"

  os_disk = {
    name = "OsDisk-1-${var.env}"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key = {
    username = "adminuser"
    public_key = module.keyvault.ssh_public_key
  }

  ip_configuration = {
    name = "ipconfig-1-${var.env}"
    subnet_id = module.networking.PublicSubnetId
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = module.networking.PublicIP
  }

  storage_account_name = "stfor${var.env}"
  

}

resource "azurerm_network_interface_security_group_association" "nic-sg-association" {
  network_interface_id      = module.vm-1.nic_id
  network_security_group_id = module.networking.nsg_id
}


module "vm-2" {
  source = "./modules/vm"
  env = var.env
  vm_name = "vm-2-${var.env}"
  rg_name = var.rg_name[var.env]
  rg_location = var.rg_location
  vm_size = "Standard_DS1_v2"
  computer_name = "vm-2-${var.env}"

  os_disk = {
    name = "OsDisk-2-${var.env}"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key = {
    username = "adminuser"
    public_key = module.keyvault.ssh_public_key
  }

  ip_configuration = {
    name = "ipconfig-2-${var.env}"
    subnet_id = module.networking.PublicSubnetId
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = null
  }

  storage_account_name = "stfor${var.env}"

}
