resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "yuliia-test-project"
  tags = {
    owner = "yuliia.bashko"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "pr_network" {
  name                = "project-vnet"
  address_space       = ["10.8.0.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "pr_subnet" {
  name                 = "project-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.pr_network.name
  address_prefixes     = ["10.8.0.0/26"]
}

# Create public IPs
resource "azurerm_public_ip" "scm_public_ip" {
  name                = "scm-pub-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "scm_nsg" {
  name                = "scm-network-security-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "194.44.0.0/16"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "194.44.0.0/16"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "scm_nic" {
  name                = "scm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "scm_nic_configuration"
    subnet_id                     = azurerm_subnet.pr_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.scm_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "scm_nsg_to_nic" {
  network_interface_id      = azurerm_network_interface.scm_nic.id
  network_security_group_id = azurerm_network_security_group.scm_nsg.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "scm_vm" {
  name                  = "scm-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.scm_nic.id]
  size                  = "Standard_B4ms"

  os_disk {
    name                 = "scm-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "scm-vm"
  admin_username                  = "azureuser"
  disable_password_authentication = false
  admin_password = "Vmadmin789&*("
}


# Jenkins vm

# Create public IPs
resource "azurerm_public_ip" "jenkins_public_ip" {
  name                = "jenkins-pub-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "jenkins_nsg" {
  name                = "jenkins-network-security-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "194.44.0.0/16"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "194.44.0.0/16"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "jenkins_nic" {
  name                = "jenkins-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "jenkins_nic_configuration"
    subnet_id                     = azurerm_subnet.pr_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "jenkins_nsg_to_nic" {
  network_interface_id      = azurerm_network_interface.jenkins_nic.id
  network_security_group_id = azurerm_network_security_group.jenkins_nsg.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "jenkins_vm" {
  name                  = "jenkins-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.jenkins_nic.id]
  size                  = "Standard_B4ms"

  os_disk {
    name                 = "jenkins-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "jenkins-vm"
  admin_username                  = "azureuser"
  disable_password_authentication = false
  admin_password = "Jenkins789&*("
}


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
      scm_pr_ip = azurerm_linux_virtual_machine.scm_vm.private_ip_address
    }
  )
  filename = "../configuration/var.yaml"
}