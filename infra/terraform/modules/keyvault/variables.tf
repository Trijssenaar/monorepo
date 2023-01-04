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

variable "rbac" {
  type = map(object({
    object_ids = list(string)
  }))
  description = "Define Azure Key Vault rbac roles"
  default     = {}
  validation {
    condition = alltrue([
      for role_key, role in var.rbac : contains(["keyvault_secrets_officer", "keyvault_secrets_user", "keyvault_certificate_officer", "keyvault_administrator"], role_key)
    ])

    error_message = "A rbac can only be defined for one of [keyvault_secrets_officer, keyvault_secrets_user, keyvault_certificate_officer, keyvault_administrator]!"
  }
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

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID"
}
