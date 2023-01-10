variable "keyvault_name" {
  type        = string
  description = "Name of the Key Vault"
}

variable "keyvault_location" {
  type        = string
  description = "Location of the Key Vault"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "sku_name" {
  type    = string
  default = "premium"
}

variable "enabled_for_deployment" {
  type        = bool
  default     = false
  description = "Enable the Key Vault for VM deployment"
}

variable "enabled_for_disk_encryption" {
  type        = bool
  default     = false
  description = "Enable the Key Vault for disk encryption"
}

variable "enabled_for_template_deployment" {
  type        = bool
  default     = false
  description = "Enable the Key Vault for ARM template deployment"
}

variable "support_name" {
  type        = string
  description = "Name of the support team"
}

variable "support_email" {
  type        = string
  description = "Email address of the support team"
}

variable "policies" {
  type = map(object({
    object_ids              = list(string)
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
    storage_permissions     = list(string)
  }))
  description = "Define Azure Key Vault access policies"
  default     = {}
}

variable "certificates" {
  type = map(object({
    name      = string
    subject   = string
    dns_names = list(string)
  }))
  description = "Define Azure Key Vault certificates"
}

variable "secrets" {
  type = map(object({
    value = string
  }))
  description = "Define Azure Key Vault secrets"
}
