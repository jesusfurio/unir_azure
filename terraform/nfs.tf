#################
# Azure VMs NFS #
#################
resource "azurerm_virtual_machine" "unir_nfs" {
    name                  = "nfs.${var.vm_name}"
    location              = azurerm_resource_group.unir_rg.location
    resource_group_name   = azurerm_resource_group.unir_rg.name
    network_interface_ids = [azurerm_network_interface.unir_nfs_nic.id]
    vm_size                  = "Standard_DS1_v2"

    storage_os_disk {
        name              = "nfsosdisk.disk0"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    storage_image_reference {
        publisher = "OpenLogic"
        offer     = "Centos"
        sku       = "8_2"
        version   = "latest"
    }
    storage_data_disk {
        name              = azurerm_managed_disk.unir_nfs_manageddisk.name
        managed_disk_id   = azurerm_managed_disk.unir_nfs_manageddisk.id
        create_option     = "Attach"
        lun               = 1
        disk_size_gb      = azurerm_managed_disk.unir_nfs_manageddisk.disk_size_gb
    }
    os_profile {
        computer_name  = "nfs.${var.vm_name}"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

# Create network interface
resource "azurerm_network_interface" "unir_nfs_nic" {
    name                      = "nfs_nic.eth0"
    location                  = azurerm_resource_group.unir_rg.location
    resource_group_name       = azurerm_resource_group.unir_rg.name

    ip_configuration {
        name                          = "VMNicConfiguration"
        subnet_id                     = azurerm_subnet.unir_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}
# Create data disk attached to virtual machine
resource "azurerm_managed_disk" "unir_nfs_manageddisk" {
    name                 = "nfs.disk1"
    location             = azurerm_resource_group.unir_rg.location
    resource_group_name  = azurerm_resource_group.unir_rg.name
    storage_account_type = "Standard_LRS"
    create_option        = "Empty"
    disk_size_gb         = "10"
}

resource "azurerm_public_ip" "public_ip_nfs" {
    name                = "nfsip"
    location            = azurerm_resource_group.unir_rg.location
    resource_group_name = azurerm_resource_group.unir_rg.name
    allocation_method   = "Dynamic"
    sku                 = "Basic"
}