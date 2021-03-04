# main virtual net
resource "azurerm_virtual_network" "cp2_network" {
  name = "net.${azurerm_resource_group.cp2_rg.name}"
  location = azurerm_resource_group.cp2_rg.location
  resource_group_name = azurerm_resource_group.cp2_rg.name
  address_space = ["10.0.0.0/16"]
}

# main virtual subnet
resource "azurerm_subnet" "cp2_subnet" {
  name = "subnet.${azurerm_resource_group.cp2_rg.name}"
  resource_group_name = azurerm_resource_group.cp2_rg.name
  virtual_network_name = azurerm_virtual_network.cp2_network.name
  address_prefix = "10.0.1.0/24"
}

# network security group
resource "azurerm_network_security_group" "cp2_nsg" {
  name = "security.${azurerm_resource_group.cp2_rg.name}"
  location = azurerm_resource_group.cp2_rg.location
  resource_group_name = azurerm_resource_group.cp2_rg.name
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
  security_rule {
    name = "nodeport"
    priority = 1002
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "30000"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}
# subnet association to nsg
resource "azurerm_subnet_network_security_group_association" "cp2_snsga" {
  subnet_id = azurerm_subnet.cp2_subnet.id
  network_security_group_id = azurerm_network_security_group.cp2_nsg.id
}