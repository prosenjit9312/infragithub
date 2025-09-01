variable "rg_name" { type = string }
variable "location" { type = string }
variable "subnet_id" { type = string }
variable "nic_name" { type = string }

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

output "nic_id" {
  value = azurerm_network_interface.nic.id
}
