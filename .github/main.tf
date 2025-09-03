terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

############################
# Variables (inline)
############################
variable "location" {
  default = "East US"
}
variable "vm_size" {
  default = "Standard_B1s"
}
variable "admin_username" {
  default = "devops"
}
variable "admin_password" {
  default   = "P@ssw0rd123!"
  sensitive = true
}

############################
# Resource Group
############################
resource "azurerm_resource_group" "brg" {
  name     = "brg"
  location = var.location
}

############################
# Storage Account (boot diagnostics)
############################
resource "azurerm_storage_account" "bstorage" {
  name                     = "bstorage1234" # globally unique hona chahiye
  resource_group_name      = azurerm_resource_group.brg.name
  location                 = azurerm_resource_group.brg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false
  min_tls_version          = "TLS1_2"
}

############################
# Networking
############################
resource "azurerm_virtual_network" "bvnet" {
  name                = "bvnet"
  resource_group_name = azurerm_resource_group.brg.name
  location            = azurerm_resource_group.brg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "bsubnet" {
  name                 = "bsubnet"
  resource_group_name  = azurerm_resource_group.brg.name
  virtual_network_name = azurerm_virtual_network.bvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "bvm_pip" {
  name                = "bvm-pip"
  resource_group_name = azurerm_resource_group.brg.name
  location            = azurerm_resource_group.brg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "bvm_nsg" {
  name                = "bvm-nsg"
  resource_group_name = azurerm_resource_group.brg.name
  location            = azurerm_resource_group.brg.location

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "bvm_nic" {
  name                = "bvm-nic"
  resource_group_name = azurerm_resource_group.brg.name
  location            = azurerm_resource_group.brg.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.bsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bvm_pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "bvm_nic_nsg" {
  network_interface_id      = azurerm_network_interface.bvm_nic.id
  network_security_group_id = azurerm_network_security_group.bvm_nsg.id
}

############################
# Linux VM
############################
resource "azurerm_linux_virtual_machine" "bvm" {
  name                = "bvm"
  resource_group_name = azurerm_resource_group.brg.name
  location            = azurerm_resource_group.brg.location
  size                = var.vm_size
  admin_username      = var.admin_username

  admin_password                  = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.bvm_nic.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    name                 = "bvm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.bstorage.primary_blob_endpoint
  }
}

############################
# Outputs
############################
output "bvm_public_ip" {
  value = azurerm_public_ip.bvm_pip.ip_address
}

output "bvm_ssh" {
  value = "ssh ${var.admin_username}@${azurerm_public_ip.bvm_pip.ip_address}"
}
