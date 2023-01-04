output "keyvault_id" {
  value       = azurerm_key_vault.main.id
  description = "Created Key Vault Id"
}

# not used but here to make sure it is created before the system plane continues
# depens_on will wait untill this output is known
output "secret" {
  value     = azurerm_key_vault_secret.secret
  sensitive = true
}
