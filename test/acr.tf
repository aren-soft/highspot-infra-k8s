locals {
  registry_region    = local.regions.eastus
  resource_group     = local.registry_names.eastus.resource_group
  container_registry = local.registry_names.eastus.container_registry
}

resource "azurerm_resource_group" "rg_acr" {
  name     = local.resource_group[0]
  location = local.registry_region
  tags     = local.tags
}

locals {
  registry_rg = azurerm_resource_group.rg_acr
}

resource "azurerm_container_registry" "acr" {
  resource_group_name           = local.registry_rg.name
  name                          = local.container_registry[0]
  location                      = local.registry_rg.location
  public_network_access_enabled = true
  sku                           = "Standard"
  tags                          = local.tags
}

locals {
  registry = azurerm_container_registry.acr
}
