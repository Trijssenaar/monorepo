terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
  }
  backend "azurerm" {}

  required_version = "1.3.6"
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
  resource_group_name = "demo-${lower(var.environment)}-rg"
  location            = var.location
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    prevent_destroy = true
  }
}

module "module-name" {
  source = "trijssenaar.jfrog.io/infrastructure-terraform-local__monorepo/modules-keyvault/azurerm"
}
