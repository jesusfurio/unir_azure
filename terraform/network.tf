###################
# Azure VNet Main #
###################
resource "azurerm_virtual_network" "unir_network" {
    name                = "${azurerm_resource_group.unir_rg.name}.network.d01"
    location            = azurerm_resource_group.unir_rg.location
    resource_group_name = azurerm_resource_group.unir_rg.name
    address_space       = var.azure-vnet-range  
}
##################
# Azure Subnet 1 #
##################
resource "azurerm_subnet" "unir_subnet" {
    name                 = "${azurerm_virtual_network.unir_network.name}-192.168.1.0-24"
    resource_group_name  = azurerm_resource_group.unir_rg.name
    virtual_network_name = azurerm_virtual_network.unir_network.name
    address_prefix     = "${var.azure-subnet-range}"
}
# Network Security Group
resource "azurerm_network_security_group" "unir_nsg" {
    name                = "${azurerm_virtual_network.unir_network.name}-192.168.1.0-24.nsg"
    location            = azurerm_resource_group.unir_rg.location
    resource_group_name = azurerm_resource_group.unir_rg.name
    security_rule {
        name = "ssh"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
  }
}
# Subnet association to NSG
resource "azurerm_subnet_network_security_group_association" "unir_sb-net_asso" {
  subnet_id                 = azurerm_subnet.unir_subnet.id
  network_security_group_id = azurerm_network_security_group.unir_nsg.id
}