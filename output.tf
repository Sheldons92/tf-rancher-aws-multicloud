output "rke_nodes" {
  value = module.rke_infra.rke_nodes
  sensitive = true
}

resource "local_file" "clusteryml" {
  content = templatefile("cluster.yml.tpl", {
    nodes              = module.rke_infra.rke_nodes,
    cluster_name       = var.cluster_name,
    kubernetes_version = var.kubernetes_version
  })
  filename = "cluster.yml"
}
