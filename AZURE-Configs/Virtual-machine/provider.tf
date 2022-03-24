terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id = "" #To show subscription_id az account show --query id --output tsv
  # client_id       = ""
  tenant_id = "" #To show tenant_id az account tenant list
}
