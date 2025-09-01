variable "rg_name" { type = string }
variable "location" { type = string }
variable "vm_name" { type = string }
variable "nic_id" { type = string }
variable "admin_user" { type = string }
variable "admin_password" { type = string }

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = var.rg_name
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = var.admin_user
  admin_password        = var.admin_password
  network_interface_ids = [var.nic_id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

output "vm_id" {
  value = azurerm_windows_virtual_machine.vm.id
}
