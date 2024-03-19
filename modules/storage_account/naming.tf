module "naming_sa" {
  source       = "../../modules/naming"
  product_area = var.product_area
  environment  = var.environment
  location     = var.location
  generator = {
    storages = {
      storage_account = 1
      resource_group  = 1
    }
  }
}

locals {
  naming_sa = module.naming_sa
}
