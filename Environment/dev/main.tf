module "azurerm_resource_group" {
  source = "../../module/azurerm_resource_group"
  rgs = var.rgs
}

module "azurerm_storage_account" {
  depends_on = [module.azurerm_resource_group]
  source = "../../module/azurerm_storage_account"
  storage_accounts = var.storage_accounts
}
 module "azurerm_virtual_network" {
  depends_on = [module.azurerm_resource_group]
  source = "../../module/azurerm_virtual_network"
  vnets = var.vnets
 }
 module "azurerm_subnet" {
  depends_on = [module.azurerm_virtual_network, module.azurerm_resource_group]
  source = "../../module/azurerm_subnet"
  subnets = var.subnets
 }
module "azurerm_public_IP" {
  depends_on = [module.azurerm_resource_group]
  source = "../../module/azurerm_public_IP"
  public_ips = var.public_ips
}
module "azurerm_virtual_machine" {
  depends_on = [module.azurerm_subnet, module.azurerm_public_IP, module.azurerm_resource_group]
  source = "../../module/azurerm_virtual_machine"
  vms = var.vms
}