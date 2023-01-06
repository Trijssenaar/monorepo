locals {
  environment         = var.environment
  resource_group_name = var.resource_group_name
  location            = var.location

  keyvault_name                = "main-${random_string.keyvault_suffix.result}-kv" #use variable instead of module due to circular dependency
  log_analytics_workspace_name = "main-lws"
  support_name                 = "Sander Trijssenaar"
  support_email                = "strijssenaar@xpirit.com"
  short_name                   = "support-team"

  secrets_officers = []
  certificate_officers = []
}

resource "azurerm_resource_group" "shared-grid" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    prevent_destroy = true
  }
}

resource "random_string" "keyvault_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "random_password" "admin_password" {
  length  = 32
  special = true
  upper   = true
}

resource "tls_private_key" "ssh_virtual_machines" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "keyvault" {
  source  = "trijssenaar.jfrog.io/infrastructure-terraform-local__monorepo/keyvault/azurerm"
  version = "0.1.0.76"

  keyvault_name       = local.keyvault_name
  resource_group_name = resource.azurerm_resource_group.shared-grid.name
  keyvault_location   = resource.azurerm_resource_group.shared-grid.location

  sku_name                        = "premium"
  enabled_for_deployment          = "true"
  enabled_for_disk_encryption     = "true"
  enabled_for_template_deployment = "true"
  support_name                    = local.support_name
  support_email                   = local.support_email
  log_analytics_workspace_id      = module.log_analytics_workspace.id

  rbac = {
    keyvault_administrator = {
      object_ids = [data.azurerm_client_config.current.object_id]
    }

    keyvault_secrets_officer = {
      # object_ids = flatten([data.azurerm_client_config.current.object_id, local.secrets_officers])
      object_ids = flatten([data.azurerm_client_config.current.object_id])
    }

    keyvault_certificate_officer = {
      # object_ids = flatten([data.azurerm_client_config.current.object_id, local.certificate_officers])
      object_ids = flatten([data.azurerm_client_config.current.object_id])
    }
  }

  certificates = {
    "trijssenaar-cert" = {
      name      = "trijssenaar-cert"
      subject   = "CN=temporary"
      dns_names = ["domain.com", "www.domain.com"]
    }
  }

  secrets = {
    "PRIVATE-KEY-PEM"    = { value = tls_private_key.ssh_virtual_machines.private_key_pem }
    "PUBLIC-KEY-OPENSSH" = { value = tls_private_key.ssh_virtual_machines.public_key_openssh }
    "VM-ADMIN-PASSWORD"  = { value = random_password.admin_password.result },
    "UNDEFINED"          = { value = "Known after applayer" }
  }
}

module "action_group_support" {
  source  = "trijssenaar.jfrog.io/infrastructure-terraform-local__monorepo/monitor-action-group/azurerm"
  version = "0.1.0.41"

  resource_group_name = azurerm_resource_group.shared-grid.name

  support_name  = local.support_name
  support_email = local.support_email
  action_group = {
    name       = "support-${local.environment}"
    short_name = local.environment
  }
}

module "log_analytics_workspace" {
  source  = "trijssenaar.jfrog.io/infrastructure-terraform-local__monorepo/log-analytics/azurerm"
  version = "0.1.0.39"

  name                = local.log_analytics_workspace_name
  resource_group_name = azurerm_resource_group.shared-grid.name
  location            = resource.azurerm_resource_group.shared-grid.location

  actiongroup_id = module.action_group_support.actiongroup_id
}
