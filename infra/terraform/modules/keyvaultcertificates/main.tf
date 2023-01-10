# Create an Azure Key Vault certificate
resource "azurerm_key_vault_certificate" "certificate" {
  name         = var.certificate.name
  key_vault_id = var.keyvault_id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_type   = "RSA"
      key_size   = 2048
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "EmailContacts"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = var.certificate.dns_names
      }

      subject            = var.certificate.subject
      validity_in_months = 12
    }

  }

  lifecycle {
    ignore_changes = all
  }
}
