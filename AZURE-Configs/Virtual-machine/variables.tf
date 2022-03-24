variable "location" {
  type        = string
  description = "Please enter the location"
  default     = "centralindia"
}


variable "vnet-name" {
  type        = string
  description = "Please enter the VNET name"
}



variable "subnet-name" {
  type        = string
  description = "Please enter the subnet name"
}

variable "public-ip" {
  type        = string
  description = "Please enter the Public IP"
}


variable "security-group" {
  type        = string
  description = "Please enter the Security group name"
}


variable "storage_account" {
  type        = string
  description = "Please enter the storage account name"
}


