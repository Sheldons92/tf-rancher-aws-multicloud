# Outputs

output "kubeconfig_api_server_url" {
  value = rke_cluster.cluster.api_server_url
}

output "kubeconfig_client_cert" {
  value = rke_cluster.cluster.client_cert
  sensitive = true
}

output "kubeconfig_client_key" {
  value = rke_cluster.cluster.client_key
  sensitive = true
}

output "kubeconfig_ca_crt" {
  value = rke_cluster.cluster.ca_crt
  sensitive = true
}

output "kubeconfig_yaml" {
  value = rke_cluster.cluster.kube_config_yaml
  sensitive = true
}