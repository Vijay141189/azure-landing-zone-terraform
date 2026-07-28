# Current subscription ka tenant_id aur deploy karne wale user/SP ka object_id
data "azurerm_client_config" "current" {}

# Key Vault(s) create karo
resource "azurerm_key_vault" "kv" {
  for_each = var.key_vaults

  name                        = each.value.name
  resource_group_name         = each.value.resource_group_name
  location                    = each.value.location
  tenant_id                   = coalesce(each.value.tenant_id, data.azurerm_client_config.current.tenant_id)
  sku_name                    = each.value.sku_name
  purge_protection_enabled    = each.value.purge_protection_enabled
  soft_delete_retention_days  = each.value.soft_delete_retention_days
  enable_rbac_authorization   = true
}

# Terraform chalane wale user/service principal (ya specify kiya hua object_id) ko secrets read/write ka access do (RBAC)
resource "azurerm_role_assignment" "kv_secrets_officer" {
  for_each = var.key_vaults

  scope                = azurerm_key_vault.kv[each.key].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = coalesce(each.value.object_id, data.azurerm_client_config.current.object_id)
}

# Har Key Vault ke liye ek random strong VM admin password generate karo
resource "random_password" "vm_admin_password" {
  for_each = var.key_vaults

  length           = 20
  special          = true
  override_special = "!@#$%^&*()-_=+"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
}

# Generated password ko Key Vault me secret ki tarah store karo
resource "azurerm_key_vault_secret" "vm_admin_password" {
  for_each = var.key_vaults

  name         = "${each.value.name}-vm-admin-password"
  value        = random_password.vm_admin_password[each.key].result
  key_vault_id = azurerm_key_vault.kv[each.key].id

  depends_on = [azurerm_role_assignment.kv_secrets_officer]
}
