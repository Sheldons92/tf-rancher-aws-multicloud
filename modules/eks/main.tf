# Create a new rancher2 Cloud Credential
resource "rancher2_cloud_credential" "aws" {
  name = "rancherpso_aws"
  description = "Cloud credentials for RancherPSO space on AWS"
  amazonec2_credential_config {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }
}

output "cloud_credential" {
  value = rancher2_cloud_credential.aws.id
}


resource "rancher2_cluster" "eks_cluster" {
  name = var.eks_cluster_name
  description = "Terraform EKS cluster"
  eks_config_v2 {
    cloud_credential_id = rancher2_cloud_credential.aws.id
    region = "eu-west-2"
    kubernetes_version = "1.21"
    # logging_types = ["audit", "api"]
    node_groups {
      name = "node_group1"
      instance_type = "t3.medium"
      desired_size = 3
      max_size = 5
    }
    # node_groups {
    #   name = "node_group2"
    #   instance_type = "m5.xlarge"
    #   desired_size = 2
    #   max_size = 3
    # }
    private_access = false
    public_access = true
  }
}

