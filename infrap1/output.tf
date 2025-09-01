output "resource_group_name" {
  value = module.rg.rg_name
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "subnet_id" {
  value = module.network.subnet_id
}

output "vm1_id" {
  value = module.vm1.vm_id
}

output "vm2_id" {
  value = module.vm2.vm_id
}

output "bastion_public_ip" {
  value = module.bastion.bastion_pip
}
