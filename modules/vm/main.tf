

# creating network interface
resource "azurerm_network_interface" "nic" {
  name                = "${random_pet.prefix.id}-nic-${var.env}"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = var.ip_configuration.name
    subnet_id                     = var.ip_configuration.subnet_id 
    private_ip_address_allocation = var.ip_configuration.private_ip_address_allocation
    public_ip_address_id          = var.ip_configuration.public_ip_address_id
  }

}


# Storage account for boot diagnostics
data "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.rg_name
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "VM-QA" {
  name                  =  var.vm_name
  location              =  var.rg_location
  resource_group_name   =  var.rg_name
  network_interface_ids =  [azurerm_network_interface.nic.id]
  size                  =  var.vm_size

  os_disk {
    name                 = var.os_disk.name
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_username = var.admin_username
  computer_name  = var.computer_name

  admin_ssh_key {
    username   = var.admin_ssh_key.username
    public_key = var.admin_ssh_key.public_key
  }

  boot_diagnostics {
    storage_account_uri = data.azurerm_storage_account.storage_account.primary_blob_endpoint
  }

}

resource "random_pet" "prefix" {
  prefix = var.prefix
  length = 1
}