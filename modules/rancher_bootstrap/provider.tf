terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.22.2"
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

# provider "rancher2" {
#   alias = "bootstrap"
#   api_url  = "https://${var.rancher_hostname}"
#   bootstrap = true
#   insecure = true
# }

# provider "rancher2" {
#   alias = "admin"
#   api_url = "https://${var.rancher_hostname}"
#   token_key = module.rancher_bootstrap.token_key
#   insecure = true
# }