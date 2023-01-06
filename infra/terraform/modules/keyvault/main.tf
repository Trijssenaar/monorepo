locals {
  rbac_role_ids = {
    keyvault_secrets_officer     = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/b86a8fe4-44ce-4948-aee5-eccb2c155cd7"
    keyvault_secrets_user        = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6"
    keyvault_certificate_officer = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/a4417e6f-fecd-4de8-b567-7b0420556985"
    keyvault_administrator       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/00482a5a-887f-4fb3-b363-3b7fe8e74483"
  }

  rbac_roles = flatten([
    for rbac_key, rbac in var.rbac : [
      for object_key, object_id in rbac.object_ids : {
        role_id   = lookup(local.rbac_role_ids, rbac_key)
        object_id = object_id
      }
    ]
  ])
}

resource "azurerm_key_vault" "main" {
  name                = var.keyvault_name
  location            = var.keyvault_location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = true
  purge_protection_enabled        = false
  soft_delete_retention_days      = 7

  lifecycle {
    ignore_changes = [contact]
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

resource "azurerm_role_assignment" "rbac_role" {
  count              = length(local.rbac_roles) #use count instead of for_each due to values not being known until apply
  scope              = azurerm_key_vault.main.id
  role_definition_id = local.rbac_roles[count.index].role_id
  principal_id       = local.rbac_roles[count.index].object_id
}

resource "null_resource" "add_contacts" {
  provisioner "local-exec" {
    // add az cli command to add certificate contact to keyvault when it does not exists already
    command = "az keyvault certificate contact list --vault-name ${var.keyvault_name} | jq -r '.[].emailAddress' | grep -q ${var.support_email} || az keyvault certificate contact add --vault-name ${var.keyvault_name} --email ${var.support_email} --name ${var.support_name}"
    when    = create
  }
  depends_on = [
    azurerm_role_assignment.rbac_role
  ]
}

resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                       = "diag"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AzurePolicyEvaluationDetails"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

module "keyvaultcertificates" {
  source  = "trijssenaar.jfrog.io/infrastructure-terraform-local__monorepo/keyvaultcertificates/azurerm"
  version = "0.1.0.42"

  for_each = var.certificates

  keyvault_id = azurerm_key_vault.main.id
  certificate = each.value

  depends_on = [
    azurerm_role_assignment.rbac_role
  ]
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.secrets

  name         = each.key
  value        = each.value.value
  key_vault_id = azurerm_key_vault.main.id

  lifecycle {
    ignore_changes = all
  }

  depends_on = [
    azurerm_role_assignment.rbac_role
  ]
}
