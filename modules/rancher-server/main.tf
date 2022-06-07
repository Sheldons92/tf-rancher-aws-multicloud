# Install cert-manager helm chart
resource "helm_release" "cert_manager" {
  repository = "https://charts.jetstack.io"
  name       = "jetstack"
  chart      = "cert-manager"
  version    = var.cert_manager.version
  namespace  = var.cert_manager.ns
  create_namespace = true

  dynamic set {
    for_each = var.cert_manager.chart_set
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}

# resource "null_resource" "delay" {
#   depends_on = [helm_release.cert_manager]
#   provisioner "local-exec" {
#     command = "sleep 320"
#   }
# }


# # # Install Rancher helm chart
resource "helm_release" "rancher_server" {
  repository = "https://releases.rancher.com/server-charts/${var.rancher_server.branch}"
  name       = "rancher-${var.rancher_server.branch}"
  chart      = "rancher"
  version    = var.rancher_server.version
  namespace  = var.rancher_server.ns
  create_namespace = true

  set {
    name  = "hostname"
    value = var.rancher_hostname
  }

  set {
    name  = "replicas"
    value = var.rancher_replicas
  }

  dynamic set {
    for_each = var.rancher_server.chart_set
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

# #   depends_on = [
# #     helm_release.cert_manager, null_resource.delay
# #   ]
  }


  