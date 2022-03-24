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
  subscription_id = "" #To get the subscription_id az account show --query id --output tsv
  tenant_id = "" #To get the tenant_id az account tenant list
}




