
data "azurerm_client_config" "current" {}


# create Key Vault for storing ssh keys

resource "azurerm_key_vault" "KeyVault" {
  name                        = "${var.prefix}-keyvault-${var.env}"
  location                    = var.rg_location
  resource_group_name         = var.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List",
      "Delete",
      "Recover",
      "Backup",
      "Restore",  
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "List",
      "Recover",
      "Backup",
      "Restore",
      "Purge",

    ]

    storage_permissions = [
      "Get",
      "List",
      "Delete",
      "Set",
      "Update",
      "RegenerateKey",
      "Recover",
      "Backup",
      "Restore",
      "Purge",
    ]
  }
}


# generate ssh keys pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save SSH private key in Key Vault  
resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = "ssh-private-key"
  value        = tls_private_key.ssh_key.private_key_pem
  key_vault_id = azurerm_key_vault.KeyVault.id
}

resource "azurerm_key_vault_secret" "ssh_public_key" {
  name = "ssh-public-key"
  value = tls_private_key.ssh_key.public_key_openssh
  key_vault_id = azurerm_key_vault.KeyVault.id
}

