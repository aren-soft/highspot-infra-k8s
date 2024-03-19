resource "azurerm_resource_group" "rg_storage_account" {
  name     = local.naming_sa.generated_names.storages.resource_group[0]
  location = var.location
  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = local.naming_sa.generated_names.storages.storage_account[0]
  resource_group_name      = azurerm_resource_group.rg_storage_account.name
  location                 = var.location
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"
  account_replication_type = "LRS"

  blob_properties {
    delete_retention_policy {
      days = var.delete_retention_policy
    }
    versioning_enabled = var.versioning_enabled

    # until support client authentication
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "HEAD", "OPTIONS", "PUT"]
      allowed_origins    = var.allowed_origins
      exposed_headers    = ["*"]
      max_age_in_seconds = 200
    }
  }
}

resource "azurerm_storage_container" "container" {
  for_each              = var.containers
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "container" # until support client authentication
  name                  = each.value.name
}
