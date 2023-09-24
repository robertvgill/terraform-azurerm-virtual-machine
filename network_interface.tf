resource "azurerm_network_interface" "linux_nic" {
  for_each                      = var.vm_linux_virtual_machines

  resource_group_name           = var.rg_resource_group_name
  location                      = var.rg_location

  name                          = "nic-${each.value.name}"
  dns_servers                   = var.vm_dns_servers
  enable_ip_forwarding          = var.vm_enable_ip_forwarding
  enable_accelerated_networking = var.vm_enable_accelerated_networking
  internal_dns_name_label       = var.vm_internal_dns_name_label
  tags                          = merge({ "ResourceName" = format("%s", each.value.name) }, var.tags, )

  ip_configuration {
    name                          = each.value.name
    primary                       = true
    subnet_id                     = data.azurerm_subnet.vm_linux[0].id
    private_ip_address_allocation = each.value.private_ip != null ? "Static" : "Dynamic"
    private_ip_address            = each.value.private_ip != null ? each.value.private_ip : null
//    private_ip_address            = var.vm_private_ip_address_allocation_type == "Static" ? element(concat(var.vm_private_ip_address, [""])) : null
//    public_ip_address_id          = var.vm_public_ip_enable == true ? element(concat(azurerm_public_ip.pip.*.id, [""])) : null
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_network_interface" "windows_nic" {
  for_each                      = var.vm_windows_virtual_machines

  resource_group_name           = var.rg_resource_group_name
  location                      = var.rg_location

  name                          = "nic-${each.value.name}"
  dns_servers                   = var.vm_dns_servers
  enable_ip_forwarding          = var.vm_enable_ip_forwarding
  enable_accelerated_networking = var.vm_enable_accelerated_networking
  internal_dns_name_label       = var.vm_internal_dns_name_label
  tags                          = merge({ "ResourceName" = format("%s", each.value.name) }, var.tags, )

  ip_configuration {
    name                          = each.value.name
    primary                       = true
    subnet_id                     = data.azurerm_subnet.vm_windows[0].id
    private_ip_address_allocation = each.value.private_ip != null ? "Static" : "Dynamic"
    private_ip_address            = each.value.private_ip != null ? each.value.private_ip : null
//    private_ip_address            = var.vm_private_ip_address_allocation_type == "Static" ? element(concat(var.vm_private_ip_address, [""])) : null
//    public_ip_address_id          = var.vm_public_ip_enable == true ? element(concat(azurerm_public_ip.pip.*.id, [""])) : null
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}