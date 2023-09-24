## linux virtual machine
resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each   = var.vm_linux_virtual_machines

  depends_on = [
    azurerm_network_interface.linux_nic,
  ]

  resource_group_name             = var.rg_resource_group_name
  location                        = var.rg_location

  name                            = substr(each.value.name, 0, 64)
  size                            = each.value.size
  admin_username                  = var.vm_virtual_machine_config.disable_password_authentication == false && var.vm_virtual_machine_config.admin_username != null ? var.vm_virtual_machine_config.admin_username : data.azurerm_key_vault_secret.admin_username[0].value
  admin_password                  = var.vm_virtual_machine_config.disable_password_authentication == false && var.vm_virtual_machine_config.admin_password != null ? var.vm_virtual_machine_config.admin_password : data.azurerm_key_vault_secret.admin_password[0].value
  disable_password_authentication = var.vm_virtual_machine_config.disable_password_authentication
  network_interface_ids           = [azurerm_network_interface.linux_nic[each.key].id,]
  source_image_id                 = var.vm_virtual_machine_config.source_image_id != null ? var.vm_virtual_machine_config.source_image_id : null
  provision_vm_agent              = true
  allow_extension_operations      = true
  dedicated_host_id               = var.vm_virtual_machine_config.dedicated_host_id != null ? var.vm_virtual_machine_config.dedicated_host_id : null
  custom_data                     = var.vm_virtual_machine_config.custom_data != null ? var.vm_virtual_machine_config.custom_data : null
//  availability_set_id             = var.vm_enable_vm_availability_set == true ? element(concat(azurerm_availability_set.aset.*.id, [""]), 0) : null
  encryption_at_host_enabled      = var.vm_virtual_machine_config.encryption_at_host_enabled
//  proximity_placement_group_id    = var.vm_enable_proximity_placement_group ? azurerm_proximity_placement_group.appgrp.0.id : null
  zone                            = var.vm_virtual_machine_config.zone
  tags                            = merge({ "ResourceName" = format("%s", each.value.name) }, var.tags, )
/**
  dynamic "admin_ssh_key" {
    for_each = var.vm_virtual_machine_config.disable_password_authentication ? [1] : []
    content {
      username   = var.vm_virtual_machine_config.admin_username
      public_key = var.vm_admin_ssh_key_data == null ? tls_private_key.rsa[0].public_key_openssh : file(var.vm_admin_ssh_key_data)
    }
  }
**/
  dynamic "source_image_reference" {
    for_each = var.vm_virtual_machine_config.source_image_id != null ? [] : [1]
    content {
      publisher = var.vm_custom_image != null ? var.vm_custom_image["publisher"] : var.vm_linux_distribution_list[lower(each.value.image)]["publisher"]
      offer     = var.vm_custom_image != null ? var.vm_custom_image["offer"] : var.vm_linux_distribution_list[lower(each.value.image)]["offer"]
      sku       = var.vm_custom_image != null ? var.vm_custom_image["sku"] : var.vm_linux_distribution_list[lower(each.value.image)]["sku"]
      version   = var.vm_custom_image != null ? var.vm_custom_image["version"] : var.vm_linux_distribution_list[lower(each.value.image)]["version"]
    }
  }

  os_disk {
    storage_account_type      = each.value.storage_account_type
    caching                   = var.vm_virtual_machine_config.os_disk_caching
    disk_encryption_set_id    = var.vm_virtual_machine_config.os_disk_encryption_set_id
    disk_size_gb              = var.vm_virtual_machine_config.os_disk_size_gb
    write_accelerator_enabled = var.vm_virtual_machine_config.os_enable_os_disk_write_accelerator
    name                      = "dsk-${each.value.name}"
  }

  additional_capabilities {
    ultra_ssd_enabled = var.vm_virtual_machine_config.ultra_ssd_enabled
  }

  dynamic "identity" {
    for_each = var.vm_managed_identity_type != null ? [1] : []
    content {
      type         = var.vm_managed_identity_type
      identity_ids = var.vm_managed_identity_type == "UserAssigned" || var.vm_managed_identity_type == "SystemAssigned, UserAssigned" ? var.vm_managed_identity_ids : null
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.vm_virtual_machine_config.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = var.st_storage_account_name != null ? data.azurerm_storage_account.st.0.primary_blob_endpoint : var.vm_storage_account_uri
    }
  }

  lifecycle {
    ignore_changes = [
      admin_username,
      admin_password,
      identity,
      tags,
    ]
  }
}
