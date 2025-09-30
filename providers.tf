terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.31"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">= 2.0"
    }
    azurecaf = {
      source  = "claranet/azurecaf"
      version = ">= 1.2.28"
    }
  }
}
