# k8s VMs
## master
### virtual machine
resource "azurerm_virtual_machine" "k8s_master" {
  name = "${var.virtual_machine}.${var.k8s_master}"
  location = azurerm_resource_group.cp2_rg.location
  resource_group_name = azurerm_resource_group.cp2_rg.name
  network_interface_ids = [
    azurerm_network_interface.k8s_master_nic.id]
  vm_size = "Standard_D2S_v3"
  storage_os_disk {
    name = "${var.osdisk}.${var.k8s_master}"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  storage_image_reference {
    publisher = "OpenLogic"
    offer = "Centos"
    sku = "8_2"
    version = "latest"
  }
  os_profile {
    computer_name = var.k8s_master
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path = "/home/${var.username}/.ssh/authorized_keys"
    }
  }
}

### public ip
resource "azurerm_public_ip" "k8s_master_pip" {
  name = "${var.public_ip}.${var.k8s_master}"
  resource_group_name = azurerm_resource_group.cp2_rg.name
  location = azurerm_resource_group.cp2_rg.location
  allocation_method = "Static"
  sku = "Basic"
  domain_name_label = "${var.k8s_master}-${var.dns_sufix}"
}

### network interface
resource "azurerm_network_interface" "k8s_master_nic" {
  name = "${var.nic}.${var.k8s_master}"
  location = azurerm_resource_group.cp2_rg.location
  resource_group_name = azurerm_resource_group.cp2_rg.name

  ip_configuration {
    name = "${var.ipconf}.${var.k8s_master}"
    subnet_id = azurerm_subnet.cp2_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.1.${var.first_ip}"
    public_ip_address_id = azurerm_public_ip.k8s_master_pip.id
  }
}


## workers
### virtual machines
resource "azurerm_virtual_machine" "k8s_worker" {
  count = 2
  name = "${var.virtual_machine}.${count.index}${var.k8s_worker}"
  location = azurerm_resource_group.cp2_rg.location
  resource_group_name = azurerm_resource_group.cp2_rg.name
  network_interface_ids = [element(azurerm_network_interface.k8s_worker_nic.*.id, count.index)]
  vm_size = "Standard_DS1_v2"
  storage_os_disk {
    name = "${var.osdisk}.${var.k8s_worker}${count.index}"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  storage_image_reference {
    publisher = "OpenLogic"
    offer = "Centos"
    sku = "8_2"
    version = "latest"
  }
  os_profile {
    computer_name = "${var.k8s_worker}${count.index}"
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path = "/home/${var.username}/.ssh/authorized_keys"
    }
  }
}

### public ip
resource "azurerm_public_ip" "k8s_worker_pips" {
  count = 2
  name = "${var.public_ip}.${var.k8s_worker}${count.index}"
  resource_group_name = azurerm_resource_group.cp2_rg.name
  location = azurerm_resource_group.cp2_rg.location
  allocation_method = "Static"
  sku = "Basic"
  domain_name_label = "${var.k8s_worker}${count.index}-${var.dns_sufix}"

}

### network interfaces
resource "azurerm_network_interface" "k8s_worker_nic" {
  count = 2
  name = "${var.nic}.${var.k8s_worker}${count.index}"
  location = azurerm_resource_group.cp2_rg.location
  resource_group_name = azurerm_resource_group.cp2_rg.name

  ip_configuration {
    name = "${var.ipconf}.${var.k8s_worker}${count.index}"
    subnet_id = azurerm_subnet.cp2_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.1.${count.index + var.first_ip + 1}"
    public_ip_address_id = azurerm_public_ip.k8s_worker_pips[count.index].id
  }
}