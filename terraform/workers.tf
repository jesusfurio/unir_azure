#####################
# Azure VMs Workers #
#####################
resource "azurerm_virtual_machine" "unir_worker" {
    count = 2
    name                  = "worker${count.index}.${var.vm_name}"
    location              = azurerm_resource_group.unir_rg.location
    resource_group_name   = azurerm_resource_group.unir_rg.name
    network_interface_ids = [element(azurerm_network_interface.unir_worker_nic.*.id, count.index)]
    vm_size                  = "Standard_DS1_v2"
    storage_os_disk {
        name              = "worker${count.index}osdisk.disk0"
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
    os_profile {
        computer_name  = "worker${count.index}.${var.vm_name}"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}
# Create network interface
resource "azurerm_network_interface" "unir_worker_nic" {
    count = 2
    name                      = "worker${count.index}_nic${count.index}.eth0"
    location                  = azurerm_resource_group.unir_rg.location
    resource_group_name       = azurerm_resource_group.unir_rg.name

    ip_configuration {
        name                          = "VMNicConfiguration"
        subnet_id                     = azurerm_subnet.unir_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}