resource "rancher2_cloud_credential" "foo-google" {
  name = "foo-google"
  description= "Terraform cloudCredential acceptance test"
  google_credential_config {
    auth_encoded_json = file(<GOOGLE_AUTH_ENCODED_JSON>)
  }
}

resource "rancher2_cluster" "foo" {
  name = "foo"
  description = "Terraform GKE cluster"
  gke_config_v2 {
    name = "foo"
    google_credential_secret = rancher2_cloud_credential.foo-google.id
    region = <REGION> # Zone argument could also be used instead of region
    project_id = rancher-dev
    kubernetes_version = <K8S_VERSION>
    network = <NETWORK>
    subnetwork = <SUBNET>
    node_pools {
      initial_node_count = 1
      max_pods_constraint = 110
      name = <NODE_POOL_NAME>
      version = <VERSION>
    }
  }
}