resource "azurerm_public_ip" "public_ip" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
  zones               = var.zones
  tags                = var.tags
  sku                 = var.sku
  domain_name_label   = var.domain_name_label
}
