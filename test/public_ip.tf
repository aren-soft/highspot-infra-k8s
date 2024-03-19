module "naming_ip" {
  source       = "../modules/naming/"
  product_area = local.product_area
  environment  = local.environment
  location     = local.regions.eastus
  generator = {
    ttips = {
      public_ip = 2
    }
  }
}

module "pip" {
  source              = "../modules/public_ip/"
  for_each            = local.ips
  resource_group_name = module.kubernetes_clusters[local.regions.eastus].node_resource_group
  name                = module.naming_ip.generated_names.ttips.public_ip[each.key]
  product_area        = local.product_area
  environment         = local.environment
  location            = local.regions.eastus
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = each.value
  tags                = local.tags
}
