variable "rg_name" { type = string }
variable "location" { type = string }

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}
