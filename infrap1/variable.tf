variable "rg_name" {
  type        = string
  description = "Resource Group name without prefix"
}

variable "location" {
  type        = string
  description = "Azure location"
  default     = "East US"
}

variable "vnet_name" {
  type        = string
  description = "VNet name without prefix"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name without prefix"
}

variable "admin_user" {
  type        = string
  description = "Admin username for VM"
}

variable "admin_password" {
  type        = string
  description = "Admin password for VM"
  sensitive   = true
}
