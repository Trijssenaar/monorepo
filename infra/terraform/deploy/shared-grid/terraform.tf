terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.84.0"
    }
  }
  backend "azurerm" {}

  required_version = "1.3.7"
}