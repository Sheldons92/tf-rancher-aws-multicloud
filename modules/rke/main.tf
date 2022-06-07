resource rke_cluster "cluster" {
  ssh_agent_auth     = true
  cluster_name = "cluster"

   kubernetes_version = "v1.22.4-rancher1-1"
  dynamic "nodes" {

    for_each = var.rke_nodes

    content {
      user = nodes.value.user
      address = nodes.value.public_ip
      internal_address = nodes.value.private_ip
      role    = nodes.value.roles
    }
}
    cloud_provider {
      name = "aws"
    }

}

resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}