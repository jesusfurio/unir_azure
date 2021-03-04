#################
# Azure VMs NFS #
#################
resource "azurerm_virtual_machine" "cp2_nfs" {
  name = "${var.virtual_machine}.${var.nfs}"
  location = azurerm_resource_group.cp2_rg.location
  resource_group_name = azurerm_resource_group.cp2_rg.name
  network_interface_ids = [
    azurerm_network_interface.cp2_nfs_nic.id]
  vm_size = "Standard_DS1_v2"

  storage_os_disk {
    name = "${var.osdisk}.${var.nfs}"
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
  storage_data_disk {
    name = azurerm_managed_disk.cp2_nfs_storagedisk.name
    managed_disk_id = azurerm_managed_disk.cp2_nfs_storagedisk.id
    create_option = "Attach"
    lun = 1
    disk_size_gb = azurerm_managed_disk.cp2_nfs_storagedisk.disk_size_gb
  }
  os_profile {
    computer_name = "${var.virtual_machine}.${var.nfs}"
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
resource "azurerm_public_ip" "nfs_pip" {
  name = "${var.public_ip}.${var.nfs}"
  resource_group_name = azurerm_resource_group.cp2_rg.name
  location = azurerm_resource_group.cp2_rg.location
  allocation_method = "Static"
  sku = "Basic"
  domain_name_label = "${var.nfs}-${var.dns_sufix}"
}

# Create network interface
resource "azurerm_network_interface" "cp2_nfs_nic" {
  name = "${var.nic}.${var.nfs}"
  location = azurerm_resource_group.cp2_rg.location
  resource_group_name = azurerm_resource_group.cp2_rg.name

  ip_configuration {
    name = "${var.ipconf}.${var.nfs}"
    subnet_id = azurerm_subnet.cp2_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.1.${var.first_ip - 1}"
    public_ip_address_id = azurerm_public_ip.nfs_pip.id

  }
}
# Create data disk attached to virtual machine
resource "azurerm_managed_disk" "cp2_nfs_storagedisk" {
  name = "${var.stdisk}.${var.nfs}"
  location = azurerm_resource_group.cp2_rg.location
  resource_group_name = azurerm_resource_group.cp2_rg.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = "10"
}