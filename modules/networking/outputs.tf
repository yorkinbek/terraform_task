output "nsg_id" {
    description = "The ID of the NSG"
    value = azurerm_network_security_group.NSG.id
}

output "PublicSubnetId" {
    description = "The ID of the public subnet"
    value = azurerm_subnet.subnet["public"].id
}

output "PrivateSubnetId" {
    description = "The ID of the private subnet"
    value = azurerm_subnet.subnet["private"].id
}

output "PublicIP" {
    description = "The public IP address ID"
    value = azurerm_public_ip.public.id
}