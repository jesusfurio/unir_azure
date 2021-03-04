# resource group
resource "azurerm_resource_group" "cp2_rg" {
  name = "cp2_rg"
  location = var.region
}