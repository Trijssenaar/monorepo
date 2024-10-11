terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.5.0"
    }
  }
  backend "azurerm" {}

  required_version = "1.3.7"
}