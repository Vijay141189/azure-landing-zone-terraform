
module "azurerm_resource_group" {
  source = "../../module/azurerm_resource_group"
  rgs    = var.rgs
}

module "azurerm_storage_account" {
  depends_on       = [module.azurerm_resource_group]
  source           = "../../module/azurerm_storage_account"
  storage_accounts = var.storage_accounts
}

module "azurerm_virtual_network" {
  depends_on = [module.azurerm_resource_group]
  source     = "../../module/azurerm_virtual_network"
  vnets      = var.vnets
}

module "azurerm_subnet" {
  depends_on = [module.azurerm_virtual_network, module.azurerm_resource_group]
  source     = "../../module/azurerm_subnet"
  subnets    = var.subnets
}

module "azurerm_public_IP" {
  depends_on = [module.azurerm_resource_group]
  source     = "../../module/azurerm_public_IP"
  public_ips = var.public_ips
}

module "azurerm_key_vault" {
  depends_on = [module.azurerm_resource_group]
  source     = "../../module/azurerm_key_vault"

  key_vaults = var.key_vaults
  tags       = local.common_tags
}

# vms input me admin_password ko Key Vault se generate hue password se replace kar rahe hain,
# taaki plaintext password kahin tfvars me na rahe
locals {
  vms_with_password = {
    for k, v in var.vms : k => merge(v, {
      admin_password = module.azurerm_key_vault.vm_admin_passwords["key_vault1"]
    })
  }
}

module "azurerm_virtual_machine" {
  depends_on = [module.azurerm_subnet, module.azurerm_public_IP, module.azurerm_resource_group, module.azurerm_key_vault]
  source     = "../../module/azurerm_virtual_machine"
  vms        = local.vms_with_password

  tags = local.common_tags
}