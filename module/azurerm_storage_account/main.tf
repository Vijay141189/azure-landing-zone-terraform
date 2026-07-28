resource "azurerm_storage_account" "example" {
  for_each = var.storage_accounts

  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

  public_network_access_enabled = false

  blob_properties {
    last_access_time_enabled = true
  }

  tags = {
    Environment = "Stage"      # Dev / Stage / Prod
    Service     = "LandingZone"
  }
}