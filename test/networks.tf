locals {
  address_space = lookup(local.address_space_map, local.environment)
}

resource "azurerm_virtual_network" "virtual_network" {
  for_each            = local.names
  resource_group_name = local.main_resource_groups[each.key].name
  name                = each.value.cluster.virtual_network[0]
  location            = each.key
  address_space       = [(lookup(local.address_space, each.key)).virtual_network]
  tags                = local.tags
}

resource "azurerm_subnet" "aks_sys_pool_subnet" {
  for_each             = local.networks
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.name
  name                 = local.names[each.key].cluster.subnet[0]
  address_prefixes     = [(lookup(local.address_space, each.key)).subnet_aks_sys_pool_prefix]
}

resource "azurerm_subnet" "aks_user1_pool_subnet" {
  for_each             = local.networks
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.name
  name                 = local.names[each.key].cluster.subnet[1]
  address_prefixes     = [(lookup(local.address_space, each.key)).subnet_aks_user1_pool_prefix]
}

resource "azurerm_subnet" "aks_gtw_frontend1_subnet" {
  for_each             = local.networks
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.name
  name                 = local.names[each.key].cluster.subnet[2]
  address_prefixes     = [(lookup(local.address_space, each.key)).subnet_aks_gtwfrontend1]
  delegation {
    name = "gtwdelegation"
    service_delegation {
      name = "Microsoft.ServiceNetworking/trafficControllers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

locals {
  networks      = azurerm_virtual_network.virtual_network
  subnet_front1 = azurerm_subnet.aks_gtw_frontend1_subnet
  subnet_user1  = azurerm_subnet.aks_user1_pool_subnet
  subnet_system = azurerm_subnet.aks_sys_pool_subnet
}
