# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${random_pet.prefix.id}-vnet-${var.env}"
  address_space       = var.address_space
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
}


# Public IP
resource "azurerm_public_ip" "public" {
  name                = "${random_pet.prefix.id}-public-ip-${var.env}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

# Network Security Group
resource "azurerm_network_security_group" "NSG" {
  name                = "${random_pet.prefix.id}-nsg-${var.env}"
  location            = var.rg_location
  resource_group_name = var.rg_name
}


resource "azurerm_network_security_rule" "RDP" {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    network_security_group_name = azurerm_network_security_group.NSG.name
    resource_group_name = var.rg_name 
}

resource "azurerm_network_security_rule" "SSH" {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    network_security_group_name = azurerm_network_security_group.NSG.name 
    resource_group_name = var.rg_name
}

resource "azurerm_network_security_rule" "Monitor" {
    count                      = var.is_prod_environment ? 1 : 0
    name                       = "Monitor"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    network_security_group_name = azurerm_network_security_group.NSG.name 
    resource_group_name = var.rg_name
}

resource "random_pet" "prefix" {
  prefix = var.prefix
  length = 1
}