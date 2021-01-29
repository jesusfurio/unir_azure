# Create Resource Group
resource "azurerm_resource_group" "unir_rg" {
  name     = "unir_azure_rg"
  location = var.azure-region
}