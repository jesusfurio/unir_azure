#################
# Azure RG Vars #
#################

# Azure Region
variable "azure-region" {
  type        = string
  default = "westeurope"
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

##################
# Azure VMs Vars #
##################

variable "admin_username" {
  type        = string
  default = "admnfs"
}

variable "admin_password" {
  type        = string
  default = "P@ssw0rd12345.$"
}

variable "vm_name" {
  type        = string
  default = "azvm"
}