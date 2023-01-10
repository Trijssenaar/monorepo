resource "azurerm_key_vault" "main" {
  name                = var.keyvault_name
  location            = var.keyvault_location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  purge_protection_enabled        = false
  soft_delete_retention_days      = 7

  access_policy = flatten([
    for policy_key, policy in var.policies : [
      for object_key, object_id in policy.object_ids : {
        tenant_id               = data.azurerm_client_config.current.tenant_id
        object_id               = object_id
        application_id          = null
        key_permissions         = policy.key_permissions
        secret_permissions      = policy.secret_permissions
        certificate_permissions = policy.certificate_permissions
        storage_permissions     = policy.storage_permissions
      }
    ]
  ])

  contact {
    name  = var.support_name
    email = var.support_email
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

module "keyvaultcertificates" {
  source = "trijssenaar.jfrog.io/infrastructure-terraform-local__monorepo/keyvaultcertificates/azurerm"
  version = "0.1.5"
  for_each = var.certificates

  keyvault_id = azurerm_key_vault.main.id
  certificate = each.value
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.secrets

  name         = each.key
  value        = each.value.value
  key_vault_id = azurerm_key_vault.main.id

  lifecycle {
    ignore_changes = all
  }
}
