terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
  }
  backend "azurerm" {}

  required_version = "1.3.7"
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

locals {
  environment         = var.environment
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "shared-grid" {
  source  = "trijssenaar.jfrog.io/infrastructure-terraform-local__monorepo/shared-grid/azurerm"
  version = "0.1.0.11"

  environment = local.environment
  resource_group_name = local.resource_group_name
  location = local.location
}
