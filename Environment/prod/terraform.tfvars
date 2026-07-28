rgs = {
  rg1 = {
    name     = "resourcegroup1411-prod"
    location = "southeastasia"
  }
}

storage_accounts = {
  sa1 = {
    name                     = "storageblob1411prod" # Storage Account names cannot contain hyphens
    resource_group_name      = "resourcegroup1411-prod"
    location                 = "southeastasia"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

vnets = {
  vnet1 = {
    name                = "Terraformvnet1-prod"
    address_space       = ["10.0.0.0/16"]
    location            = "southeastasia"
    resource_group_name = "resourcegroup1411-prod"
  }
}

subnets = {
  subnet1 = {
    name                 = "frontendsubnet1-prod"
    resource_group_name  = "resourcegroup1411-prod"
    virtual_network_name = "Terraformvnet1-prod"
    address_prefixes     = ["10.0.1.0/24"]
  }
  subnet2 = {
    name                 = "backendsubnet1-prod"
    resource_group_name  = "resourcegroup1411-prod"
    virtual_network_name = "Terraformvnet1-prod"
    address_prefixes     = ["10.0.2.0/24"]
  }
}

public_ips = {
  public_ip1 = {
    name                = "publicip1-prod"
    resource_group_name = "resourcegroup1411-prod"
    location            = "southeastasia"
    allocation_method   = "Static"
  }
  public_ip2 = {
    name                = "publicip2-prod"
    resource_group_name = "resourcegroup1411-prod"
    location            = "southeastasia"
    allocation_method   = "Static"
  }
}

vms = {
  vm1 = {
    name                 = "vm-1-prod"
    resource_group_name  = "resourcegroup1411-prod"
    location             = "southeastasia"
    size                 = "Standard_B2s"
    admin_username       = "adminuser"
    # admin_password ab yaha nahi likha jaata — Key Vault module isse generate/inject karta hai
    subnet_name          = "frontendsubnet1-prod"
    public_ip_name       = "publicip1-prod"
    virtual_network_name = "Terraformvnet1-prod"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    offer                = "UbuntuServer"
    sku                  = "18.04-LTS"
    version              = "latest"
    publisher            = "Canonical"
  }
  vm2 = {
    name                 = "vm-2-prod"
    resource_group_name  = "resourcegroup1411-prod"
    location             = "southeastasia"
    size                 = "Standard_B2s"
    admin_username       = "adminuser"
    # admin_password ab yaha nahi likha jaata — Key Vault module isse generate/inject karta hai
    subnet_name          = "backendsubnet1-prod"
    public_ip_name       = "publicip2-prod"
    virtual_network_name = "Terraformvnet1-prod"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    offer                = "UbuntuServer"
    sku                  = "18.04-LTS"
    version              = "latest"
    publisher            = "Canonical"
  }
}

key_vaults = {
  key_vault1 = {
    name                        = "keyvault1411-prod"
    resource_group_name        = "resourcegroup1411-prod"
    location                   = "southeastasia"
    sku_name                    = "standard"
    purge_protection_enabled    = true
    soft_delete_retention_days  = 90
  }
}
