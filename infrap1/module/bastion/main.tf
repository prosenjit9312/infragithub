variable "rg_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "subnet_id" { type = string }

resource "azurerm_public_ip" "bastion_pip" {
  name                = "pr-bastion-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "pr-bastion"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

output "bastion_pip" {
  value = azurerm_public_ip.bastion_pip.ip_address
}
