#################
# Azure RG Vars #
#################

# Azure Region
variable "azure-region" {
  type        = string
  default = ""
}

######################
# Azure Network Vars #
######################

# Azure Virtual Network Range
variable "azure-vnet-range" {
  type        = list(string)
  default = ["192.168.1.0/24","192.168.2.0/24"]
}

# Azure Subnet Range
variable "azure-subnet-range" {
  type        = string
  default = "192.168.1.0/24"
}