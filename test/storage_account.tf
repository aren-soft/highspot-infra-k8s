module "storage_account" {
  source       = "../modules/storage_account"
  product_area = local.product_area
  environment  = local.environment
  location     = local.regions.eastus
  containers = {
    default = {
      name = "default"
    }
  }
  allowed_origins = [for ip in module.pip : "http://${ip.fqdn}:${local.cors_ports[split(".", ip.fqdn)[0]]}"]
}
