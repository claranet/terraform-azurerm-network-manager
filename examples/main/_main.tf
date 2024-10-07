terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.36"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}