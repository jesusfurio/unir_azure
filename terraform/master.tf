###################
# Azure VM Master #
###################
resource "azurerm_virtual_machine" "unir_master" {
    name                  = "master.${var.vm_name}"
    location              = azurerm_resource_group.unir_rg.location
    resource_group_name   = azurerm_resource_group.unir_rg.name
    network_interface_ids = [azurerm_network_interface.unir_master_nic.id]
    vm_size                  = "Standard_DS1_v2"
    storage_os_disk {
        name              = "masterosdisk.disk0"
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
        computer_name  = "master.${var.vm_name}"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

# Create network interface
resource "azurerm_network_interface" "unir_master_nic" {
    name                      = "master_nic.eth0"
    location                  = azurerm_resource_group.unir_rg.location
    resource_group_name       = azurerm_resource_group.unir_rg.name

    ip_configuration {
        name                          = "VMNicConfiguration"
        subnet_id                     = azurerm_subnet.unir_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_public_ip" "public_ip_master" {
    name                = "masterip"
    location            = azurerm_resource_group.unir_rg.location
    resource_group_name = azurerm_resource_group.unir_rg.name
    allocation_method   = "Dynamic"
    sku                 = "Basic"
}