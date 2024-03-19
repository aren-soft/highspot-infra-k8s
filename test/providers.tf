terraform {
  required_version = "~> 1.4.5"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.30.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.87.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy                            = false
      purge_soft_deleted_certificates_on_destroy              = false
      purge_soft_deleted_keys_on_destroy                      = false
      purge_soft_deleted_hardware_security_modules_on_destroy = false
      purge_soft_deleted_secrets_on_destroy                   = false
      recover_soft_deleted_key_vaults                         = true
      recover_soft_deleted_certificates                       = true
      recover_soft_deleted_keys                               = true
      recover_soft_deleted_secrets                            = true
    }
  }
}

# -- Context Data
data "azurerm_client_config" "current" {
}
