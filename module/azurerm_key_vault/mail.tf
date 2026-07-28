# Random strong password generate karo
resource "random_password" "vm_admin_password" {
  length           = 20
  special          = true
  override_special = "Vijay@141189"
  min_upper        = 2
  min_lower        = 9
  min_numeric      = 9
  min_special      = 5
}

# Password ko Key Vault me secret ke roop me store karo
resource "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "vm-admin-password"
  value        = random_password.vm_admin_password.result
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_secrets_officer]
}

# VM create karte waqt wahi password use karo
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "myvm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = "azureadmin"
  admin_password      = random_password.vm_admin_password.result

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}