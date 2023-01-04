variable "keyvault_id" {
  type        = string
  description = "Id of the Key Vault"
}

variable "certificate" {
  type = object({
    name = string
    subject = string
    dns_names = list(string)
  })
  description = "Define a Azure Key Vault certificate"
}
