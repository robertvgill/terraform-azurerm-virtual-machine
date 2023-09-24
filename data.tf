## key vault
data "azurerm_key_vault" "akv" {
  count               = var.akv_key_vault_name != null ? 1 : 0

  name                = format("%s", var.akv_key_vault_name)
  resource_group_name = var.rg_resource_group_name
}

data "azurerm_key_vault_secret" "admin_username" {
  count               = var.akv_key_vault_name != null ? 1 : 0

  name                = format("%s", var.vm_key_vault_secret_admin_username)
  key_vault_id        = data.azurerm_key_vault.akv[0].id
}

data "azurerm_key_vault_secret" "admin_password" {
  count               = var.akv_key_vault_name != null ? 1 : 0

  name                = format("%s", var.vm_key_vault_secret_admin_password)
  key_vault_id        = data.azurerm_key_vault.akv[0].id
}

## storage account
data "azurerm_storage_account" "st" {
  count               = var.st_storage_account_name != null ? 1 : 0

  name                = format("%s", var.st_storage_account_name)
  resource_group_name = var.rg_resource_group_name
}

## vnet
data "azurerm_virtual_network" "vnet" {
  count               = var.nw_virtual_network_name != null ? 1 : 0

  name                = format("%s", var.nw_virtual_network_name)
  resource_group_name = var.rg_resource_group_name
}

## subnets
data "azurerm_subnet" "vm_linux" {
  count               = var.nw_vnet_subnet_linux != null ? 1 : 0

  name                 = format("%s", var.nw_vnet_subnet_linux)
  virtual_network_name = var.nw_virtual_network_name
  resource_group_name  = var.rg_resource_group_name
}

data "azurerm_subnet" "vm_windows" {
  count               = var.nw_vnet_subnet_windows != null ? 1 : 0

  name                 = format("%s", var.nw_vnet_subnet_windows)
  virtual_network_name = var.nw_virtual_network_name
  resource_group_name  = var.rg_resource_group_name
}