terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.82.0"
    }
  }
  backend "azurerm" {}

  required_version = "1.3.7"
}