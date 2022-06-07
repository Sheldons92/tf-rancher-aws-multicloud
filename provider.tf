terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.24.0"
      configuration_aliases = [ rancher2.admin, rancher2.bootstrap]
    }
    rke = {
      source  = "rancher/rke"
      version = "1.3.0"
    }
  }
}

provider "rancher2" {
  alias     = "bootstrap"
  bootstrap = true
  api_url   = "https://${var.rancher_hostname}"
}

provider "rancher2" {
  alias     = "admin"
  api_url   = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
}