resource "azurerm_network_interface" "nic" {

  for_each = var.vms

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  ip_configuration {
    name = "dhondu"
    subnet_id = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = data.azurerm_public_ip.public_ip[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each             = var.vms
  name                 = each.value.name
  computer_name        = replace(each.value.name, "_", "-")
  resource_group_name  = each.value.resource_group_name
  location             = each.value.location
  size                 = each.value.size
  admin_username       = each.value.admin_username
  admin_password       = each.value.admin_password
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

os_disk {
  caching              = each.value.caching
  storage_account_type = each.value.storage_account_type
}


  source_image_reference {
  publisher = each.value.publisher
  offer     = each.value.offer
  sku       = each.value.sku
  version   = each.value.version
}
  }
