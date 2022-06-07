terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.24.0"
      configuration_aliases = [ rancher2.admin, rancher2.bootstrap]
    }
  }
}

