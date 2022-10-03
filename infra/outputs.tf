output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "scm_public_ip_address" {
  value = azurerm_linux_virtual_machine.scm_vm.public_ip_address
}

output "jenkins_public_ip_address" {
  value = azurerm_linux_virtual_machine.jenkins_vm.public_ip_address
}

output "scm_ip_address" {
  value = azurerm_linux_virtual_machine.scm_vm.private_ip_address
}

output "jenkins_ssh_user" {
  value = azurerm_linux_virtual_machine.jenkins_vm.admin_username
}

output "scm_ssh_user" {
  value = azurerm_linux_virtual_machine.scm_vm.admin_username
}

