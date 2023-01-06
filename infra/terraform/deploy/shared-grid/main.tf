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
  resource_group_name = var.resource-group-name
  location            = var.location
}

module "shared-grid" {
  source  = "trijssenaar.jfrog.io/infrastructure-terraform-local__monorepo/modules-shared-grid/azurerm"

  environment = local.environment
  resource-group-name = local.resource-group-name
  location = local.location
}
