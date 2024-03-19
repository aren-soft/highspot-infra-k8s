locals {
  environment  = "test"
  product_area = "poc"
  regions = {
    eastus = "eastus"
  }
  clusterRegion = local.regions.eastus
  tags          = data.azurerm_subscription.primary.tags

  registry_names = {
    eastus = {
      resource_group     = ["poc-ttue-acr-rg001"]
      container_registry = ["acrpochighspot"]
    }
  }

  names = {
    eastus = {
      cluster = {
        kubernetes_cluster = ["poc-aks-eastus-1"]
        managed_identity   = ["poc-mid-eastus-1"]
        public_ip          = ["poc-web-ingress"]
        resource_group     = ["poc-ttue-aks-rg001"]
        subnet             = ["nodepool-system", "nodepool-user-1", "gtwfrontend1"]
        virtual_network    = ["poc-vnet-test-eastus-1"]
      }
    }
  }

  ips = {
    0 = "highspot-frontend"
    1 = "highspot-backend"
  }

  # TODO: remove for production 
  cors_ports = {
    highspot-frontend = 3000
    highspot-backend  = 8686
  }

  # TODO: review CIDR configuration
  address_space_map = {
    test = {
      eastus = {
        virtual_network              = "10.100.0.0/16"
        subnet_aks_user1_pool_prefix = "10.100.0.0/20"
        subnet_aks_sys_pool_prefix   = "10.100.16.0/23"
        subnet_aks_gtwfrontend1      = "10.100.18.0/24"
      }
    }
  }
}
