## resource group
variable "rg_resource_group_name" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
  default     = null
}

variable "rg_location" {
  description = "Specifies the supported Azure location where the resource should be created."
  type        = string
  default     = null
}

## storage account
variable "st_storage_account_name" {
  description = "(Required) Specifies the name of the storage account. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
  type        = string
}

## key vault
variable "akv_key_vault_create" {
  description = "Controls if key vault should be created."
  type        = bool
}

variable "akv_key_vault_name" {
  description = "The name of the Azure Key Vault for PostgreSQL."
  type        = string
}

## virtual network
variable "nw_virtual_network_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "nw_vnet_subnet_linux" {
  description = "The name of the subnet for Linux-based virtual machines."
  type        = string
}

variable "nw_vnet_subnet_windows" {
  description = "The name of the subnet for Windows-based virtual machines."
  type        = string
}

## virtual machine
variable "vm_virtual_machine_create" {
  description = "Controls if Virtual Machine should be created."
  type        = bool
}

variable "vm_public_ip_enable" {
  description = "Reference to a Public IP Address to associate with the NIC."
  default     = null
}

variable "vm_internal_dns_name_label" {
  description = "The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network."
  default     = null
}

variable "vm_public_ip_config" {
  description = "Public IP configuration."
  type = object({
  allocation_method = string
  sku               = string
  sku_tier          = string
  domain_name_label = string
  zones             = list(string)
  })
  default = null
}

variable "vm_dns_servers" {
  description = "List of dns servers to use for network interface."
  default     = []
}

variable "vm_enable_ip_forwarding" {
  description = "Should IP Forwarding be enabled? Defaults to false."
  default     = true
}

variable "vm_enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled? Defaults to false."
  default     = false
}

variable "vm_linux_virtual_machines" {
  description = "For each Linux-based virtual machine, create an object that contain fields."
  default     = {}
}

variable "vm_windows_virtual_machines" {
  description = "For each Windows-based virtual machine, create an object that contain fields."
  default     = {}
}

variable "vm_virtual_machine_config" {
  description = "Virtual Machine configuration."
  type = object({
  admin_username                      = string
  admin_password                      = string
  disable_password_authentication     = bool
  source_image_id                     = string
  dedicated_host_id                   = string
  custom_data                         = string
  encryption_at_host_enabled          = bool
  zone                                = string
  os_disk_caching                     = string
  os_disk_encryption_set_id           = string
  os_disk_size_gb                     = number
  os_enable_os_disk_write_accelerator = bool
  ultra_ssd_enabled                   = bool
  enable_boot_diagnostics             = bool
  timezone                            = string
  })
  default = null
}

variable "vm_key_vault_secret_admin_username" {
  description = "The name of the secret associated with the username of the local administrator used for the Virtual Machine."
  default     = null  
}

variable "vm_key_vault_secret_admin_password" {
  description = "The name of the secret associated with the password which should be used for the local-administrator."
  default     = null  
}

variable "vm_managed_identity_type" {
  description = "The type of Managed Identity which should be assigned to the Linux Virtual Machine. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`."
  default     = null
}

variable "vm_custom_image" {
  description = "Provide the custom image to this module if the default variants are not sufficient"
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))
  default = null
}

variable "vm_linux_distribution_list" {
  description = "Pre-defined Azure Linux VM images list"
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))

  default = {
    ubuntu1804 = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    },
    ubuntu2004 = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal-daily"
      sku       = "20_04-daily-lts"
      version   = "latest"
    },
    ubuntu2004-gen2 = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal-daily"
      sku       = "20_04-daily-lts-gen2"
      version   = "latest"
    },
    ubuntu2204-gen2 = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy-daily"
      sku       = "22_04-daily-lts-gen2"
      version   = "latest"
    },
  }
}

variable "vm_windows_distribution_list" {
  description = "Pre-defined Azure Windows VM images list"
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))

  default = {
    windows10 = {
      publisher = "MicrosoftWindowsDesktop"
      offer     = "Windows-10"
      sku       = "win10-21h2-pro-g2"
      version   = "latest"
    },
    windows11 = {
      publisher = "MicrosoftWindowsDesktop"
      offer     = "Windows-11"
      sku       = "win11-21h2-pron"
      version   = "latest"
    },
  }
}

variable "vm_data_disks" {
  description = "Managed Data Disks for Azure Virtual Machine."
  type = list(object({
    name                 = string
    storage_account_type = string
    disk_size_gb         = number
  }))
  default = []
}

variable "vm_storage_account_name" {
  description = "The name of the hub storage account to store logs."
  default     = null
}

variable "vm_storage_account_uri" {
  description = "The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor. Passing a `null` value will utilize a Managed Storage Account to store Boot Diagnostics."
  default     = null
}

## tags
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}