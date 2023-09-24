locals {
  vm_data_disks = { for idx, data_disk in var.vm_data_disks : data_disk.name => {
    idx : idx,
    data_disk : data_disk,
    }
  }
}