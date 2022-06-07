terraform {
  cloud {
    organization = "Sheldonsit"

    workspaces {
      name = "rancher"
    }
  }
}

module "rke_infra" {
  source = "./modules/rke-infra-aws"

  aws_access_key       = var.aws_access_key
  aws_secret_key       = var.aws_secret_key
  aws_region           = var.aws_region
  prefix               = var.aws_prefix
  iam_instance_profile = var.iam_instance_profile
  clusterid            = var.clusterid

  node_master_count = var.node_master_count
  node_worker_count = var.node_worker_count
  node_all_count    = var.node_all_count
  route53_name      = var.route53_name
  route53_zone      = var.route53_zone
  deploy_lb         = var.deploy_lb

}

module "rke" {
  source     = "./modules/rke"
  
  rke_nodes  = "${module.rke_infra.rke_nodes}"

  depends_on = [module.rke_infra]

}

# # Rancher server Installation
  module "rancher_server" {
  # source           = "github.com/belgaied2/tf-module-rancher-server"
  source = "./modules/rancher-server"
  # depends_on = [module.rke]

  rancher_hostname = var.rancher_hostname
  rancher_k8s = {
    host                   = module.rke.kubeconfig_api_server_url
    client_certificate     = module.rke.kubeconfig_client_cert
    client_key             = module.rke.kubeconfig_client_key
    cluster_ca_certificate = module.rke.kubeconfig_ca_crt
  }
  rancher_server = {
    ns      = "cattle-system"
    version = var.rancher_version
    branch  = "latest"
    chart_set = [
      {
        name  = "ingress.tls.source"
        value = "letsEncrypt"
      },
      {
        name  = "letsEncrypt.email"
        value = "daniel.sheldon@suse.com"
      },
      {
        name  = "bootstrapPassword"
        value = var.bootstrapPassword
  }
    ]
  }
}

module rancher_bootstrap {
  source = "./modules/rancher_bootstrap"
  providers = {
  rancher2.bootstrap = rancher2.bootstrap
  rancher2.admin = rancher2.admin
}

  depends_on = [module.rancher_server]

  rancher_hostname = var.rancher_hostname
  bootstrapPassword = var.bootstrapPassword


}

module eks {
  source = "./modules/eks"
  # depends_on = [module.rancher_bootstrap ]
#   providers = {
#   rancher2.admin = rancher2.admin
# }
  api_url             = module.rancher_bootstrap.api_url
  token_key           = module.rancher_bootstrap.token_key
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
}

# module ec2 {
#   source = "./modules/ec2"
#   # depends_on = [module.rancher_bootstrap ]
# #   providers = {
# #   rancher2.admin = rancher2.admin
# # }
#   api_url             = module.rancher_bootstrap.api_url
#   token_key           = module.rancher_bootstrap.token_key
#   aws_access_key = var.aws_access_key
#   aws_secret_key = var.aws_secret_key
# }

# module gke {
#   source = "./modules/gke"
#   api_url             = module.rancher_bootstrap.api_url
#   token_key           = module.rancher_bootstrap.token_key
# }