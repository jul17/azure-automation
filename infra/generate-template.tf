# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      jenkins_ip = azurerm_linux_virtual_machine.jenkins_vm.public_ip_address
      jenkins_user = azurerm_linux_virtual_machine.jenkins_vm.admin_username
      jenkins_pass = azurerm_linux_virtual_machine.jenkins_vm.admin_password

      gitlab_ip = azurerm_linux_virtual_machine.scm_vm.public_ip_address
      gitlab_user = azurerm_linux_virtual_machine.scm_vm.admin_username
      gitlab_pass = azurerm_linux_virtual_machine.scm_vm.admin_password
    }
  )
  filename = "../configuration/hosts.cfg"
}

# generate inventory file for Ansible
resource "local_file" "var_cfg" {
  content = templatefile("${path.module}/templates/ansible-var.tpl",
    {
      jenkins_dns = "${azurerm_public_ip.jenkins_public_ip.domain_name_label}.${azurerm_resource_group.rg.location}.cloudapp.azure.com"
      gitlab_dns = "${azurerm_public_ip.scm_public_ip.domain_name_label}.${azurerm_resource_group.rg.location}.cloudapp.azure.com"
    }
  )
  filename = "../configuration/vars.yaml"
}