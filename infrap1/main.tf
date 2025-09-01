provider "azurerm" {
  features {}
}

module "rg" {
  source   = "./modules/resource_group"
  rg_name  = "pr-${var.rg_name}"
  location = var.location
}

module "network" {
  source      = "./modules/network"
  rg_name     = module.rg.rg_name
  location    = var.location
  vnet_name   = "pr-${var.vnet_name}"
  subnet_name = "pr-${var.subnet_name}"
}

module "nic_vm1" {
  source      = "./modules/nic"
  rg_name     = module.rg.rg_name
  location    = var.location
  subnet_id   = module.network.subnet_id
  nic_name    = "pr-nic-vm1"
}

module "nic_vm2" {
  source      = "./modules/nic"
  rg_name     = module.rg.rg_name
  location    = var.location
  subnet_id   = module.network.subnet_id
  nic_name    = "pr-nic-vm2"
}

module "vm1" {
  source         = "./modules/vm"
  rg_name        = module.rg.rg_name
  location       = var.location
  vm_name        = "pr-vm1"
  nic_id         = module.nic_vm1.nic_id
  admin_user     = var.admin_user
  admin_password = var.admin_password
}

module "vm2" {
  source         = "./modules/vm"
  rg_name        = module.rg.rg_name
  location       = var.location
  vm_name        = "pr-vm2"
  nic_id         = module.nic_vm2.nic_id
  admin_user     = var.admin_user
  admin_password = var.admin_password
}

module "bastion" {
  source    = "./modules/bastion"
  rg_name   = module.rg.rg_name
  location  = var.location
  vnet_name = module.network.vnet_name
  subnet_id = module.network.subnet_id
}
