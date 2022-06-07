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
  name = "ds-spot-cluster"
  description = "Terraform EKS cluster"
  eks_config_v2 {
    cloud_credential_id = rancher2_cloud_credential.aws.id
    region = "eu-west-2"
    kubernetes_version = "1.22"
    # logging_types = ["audit", "api"]
    node_groups {
      name = "spot_group"
      request_spot_instances = true
      spot_instance_types    = ["t3.large"]   
      instance_type = ""
      desired_size = 3
      max_size = 5
      resource_tags = {
        "Name" = "ds-spot-node"
        "DoNotDelete" = "true"
      }
    }
    private_access = false
    public_access = true
    tags = {
    DoNotDelete = true
  }
  }
}

output "eks_kubeconfig_yaml" {
  value = rancher2_cluster.eks_cluster.kube_config
  sensitive = true
}

resource "local_file" "eksclusteryml" {
  content = rancher2_cluster.eks_cluster.kube_config
  filename = "eks_cluster.yml"
}


resource "rancher2_app_v2" "rancher-monitoring" {
  cluster_id = rancher2_cluster.eks_cluster.id
  name = "rancher-monitoring"
  namespace = "cattle-monitoring-system"
  repo_name = "rancher-charts"
  chart_name = "rancher-monitoring"
  chart_version = "100.1.0+up19.0.3"
}