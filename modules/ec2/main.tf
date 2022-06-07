# Create a new rancher2 Cloud Credential
resource "rancher2_cloud_credential" "aws" {
  name = "rancherpso_aws2"
  description = "Cloud credentials for RancherPSO space on AWS"
  amazonec2_credential_config {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }
}

output "cloud_credential" {
  value = rancher2_cloud_credential.aws.id
}

# # Rancher node template
resource "rancher2_node_template" "template_ec2" {
  name = "EC2 Node Template 2"
  cloud_credential_id = rancher2_cloud_credential.aws.id
  engine_install_url = "https://releases.rancher.com/install-docker/20.10.sh"
  amazonec2_config {
    region = "eu-west-2"
    subnet_id = "subnet-0d18834a969f36814"
    security_group = ["default"]
    vpc_id = "vpc-046aa11b2839c0f9f"
    zone = "a"
    ami = "ami-02ead6ecbd926d792"
    instance_type = "t3.xlarge"
    iam_instance_profile = "EngineeringUsersEU"
    # tags = "kubernetes.io/cluster/rancher,owned"
  }

  depends_on = [rancher2_cloud_credential.aws]
}


resource "rancher2_cluster" "cluster_ec2_custom" {
  name         = "ec2-encrypt-automated-custom"
  description  = "Terraform"

  rke_config {
    kubernetes_version = "v1.18.20-rancher1-3"
    ignore_docker_version = false
    network {
      plugin = "canal"
    }
    services {
      etcd {
        backup_config {
          enabled = false
        }
      }
      kubelet {
        extra_args  = {
          max_pods = 70
        }
      }
      kube_api {
        secrets_encryption_config {
          enabled       = "true"
          custom_config = <<EOF
         apiVersion: apiserver.config.k8s.io/v1
         kind: EncryptionConfiguration
         Resources:
         - Providers:
           - AESCBC:
               Keys:
               - Name: k-fw5hn
                 Secret: ZW5jcnlwdG1lMTIzZW5jcnlwdG1lMTIz
             AESGCM: null
             Identity: null
             KMS: null
             Secretbox: null
           Resources:
           - secrets

EOF
        }
        
      }
    }
  }

  depends_on = [rancher2_node_template.template_ec2]
}


# # Rancher cluster
resource "rancher2_cluster" "cluster_ec2" {
  name         = "ec2-encrypt-automated"
  description  = "Terraform"

  rke_config {
    kubernetes_version = "v1.18.20-rancher1-3"
    cloud_provider {
      name = "aws"
      aws_cloud_provider {
        global {
          kubernetes_cluster_tag = "rancher"
        }
      }
    }
    ignore_docker_version = false
    network {
      plugin = "canal"
    }
    services {
      etcd {
        backup_config {
          enabled = false
        }
      }
      kubelet {
        extra_args  = {
          max_pods = 70
        }
      }
      kube_api {
        secrets_encryption_config {
          enabled       = "true"
          custom_config = <<EOF
         apiVersion: apiserver.config.k8s.io/v1
         kind: EncryptionConfiguration
         Resources:
         - Providers:
           - AESCBC:
               Keys:
               - Name: k-fw5hn
                 Secret: ZW5jcnlwdG1lMTIzZW5jcnlwdG1lMTIz
             AESGCM: null
             Identity: null
             KMS: null
             Secretbox: null
           Resources:
           - secrets

EOF
        }
        
      }
    }
  }

  depends_on = [rancher2_node_template.template_ec2]
}


# Rancher node pool
resource "rancher2_node_pool" "master_nodepool_ec2" {
  cluster_id = rancher2_cluster.cluster_ec2.id
  name = "nodepool-master"
  hostname_prefix = "ec2master-"
  node_template_id = rancher2_node_template.template_ec2.id
  quantity = 3
  control_plane = true
  etcd = true
  worker = false

  depends_on = [rancher2_node_template.template_ec2]
}


resource "rancher2_node_pool" "worker_nodepool_ec2" {
  cluster_id = rancher2_cluster.cluster_ec2.id
  name = "nodepool-worker"
  hostname_prefix = "ec2worker-"
  node_template_id = rancher2_node_template.template_ec2.id
  quantity = 1
  control_plane = false
  etcd = false
  worker = true

  depends_on = [rancher2_node_template.template_ec2]
}

# resource "rancher2_cluster" "ec2_cluster" {
#   name = "ec2-cluster"
#   description = "Terraform ec2 cluster"
#   eks_config_v2 {
#     cloud_credential_id = rancher2_cloud_credential.aws.id
#     region = "eu-west-2"
#     kubernetes_version = "1.18.20"
#     # logging_types = ["audit", "api"]
#     node_groups {
#       name = "spot_group"
#       request_spot_instances = true
#       spot_instance_types    = ["t3.large"]   
#       instance_type = ""
#       desired_size = 3
#       max_size = 5
#       resource_tags = {
#         "Name" = "ds-spot-eks-node"
#         "DoNotDelete" = "true"
#       }
#     }
#     private_access = false
#     public_access = true
#     tags = {
#     DoNotDelete = true
#   }
#   }
# }

# output "ec2_kubeconfig_yaml" {
#   value = rancher2_cluster.ec2_cluster.kube_config
#   sensitive = true
# }

# resource "local_file" "ec2clusteryml" {
#   content = rancher2_cluster.ec2_cluster.kube_config
#   filename = "eks_cluster.yml"
# }


# example, situation, possible outcome. - written = opposite.