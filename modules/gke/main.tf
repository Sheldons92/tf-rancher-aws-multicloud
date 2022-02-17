resource "rancher2_cloud_credential" "sheldon-sa-google" {
  name = "sa-google"
  description= "Terraform cloudCredential for GCP"
  google_credential_config {
    auth_encoded_json = file({
  "type": "service_account",
  "project_id": "rancher-dev",
  "private_key_id": "65430b60b209a917b4f036d55fa824181b04b0f9",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCX4zwDRknn98nB\nZJMed1N4geSZSjDjfvEGyGrWZeHB/ZKrHNgBwywud1zCIrSMzzYEy8GzrSanFkJg\nbYfvJosJSsD8IcwlHeRY9xAh9luofoAPouR65iCsdO5gKa94kjC7VAm8KYNGPDkb\nwCeOXOcytjjA7IARla9W4+sofV0SbA1zMMnvcCGAVeWUToo1SlSm3GNAOF5/Wtq0\n180AEembzEvBy42MHGqCySGPjegcrV2HFyQNyPg1Ni/qHoN2BvPVakuxvf3Em2/9\nN/kIQVhUyZutHt2QHOxNi+mOY6rcvEefU1MBejQQDNMakVmMBVIn6QUHPrdu7aco\nYKyJY3/JAgMBAAECggEADEa4hgc7V/1mGDR505+PZpERGfauJuUOtB6ky/lmGtjU\n7vGg39uXiZXqMGK/txXUZuTVHiGjmyOob8TKlODHohOhr39H0cQtvacSbbxMwjyf\nOyROVUSeZXH6Blm4LgWa3Lk5JDUywA2EDCMmz1Hg+e9SfP1giItRpbM8QYSIbkGf\nmg8L0yZ7tNB90BeSSIIolLFMR6URyf1GzWRRNRm8LsGAGKHRC+RrcqDHeeb//7Sw\nrjGdlSsXTop+TMh9WVw3BYwrWvLI2vILPNwmfXggWAxpM3sUoHMiyHVstVngtI2m\nNyafkvZdsDBbXGdIc4LkyXrlSmLiUxl3BifboWr21QKBgQDNKPSWdaRRyv9p0UfQ\nLehoYkqqzcSGt3X+3qly5/c4OSt9f6Ko+fU8oHMgEujI6Y2TUObgmZgYE3z0GOyX\n6IWlvPdUTXHGmE+COzvcS9Y1P4DdKCUt219utdE1YgjU4bpkiHc2nB1VnfJvHXd/\nIoX8cASNaJV3T47IMLEeABSSJwKBgQC9hsKonclaftx4Wb8iB43yUPKGejd1bZA+\nin3fdnIbWPpFMLeTiW5mbVHkjZXnJuly+6XDPzCDpbhrdNkVp5+76TjhGzeWoubE\nS8Cy3XInYEExWt3wrudhfBMvwxC+kXzMrJdyx8OV4G/DA/sfb6q4Vxq0KaXI5STe\nsiVMEgDEjwKBgQDA2RKwq/y99feI3HSIt96S4HIXhDyL9cAwx9S4clvsubCr02Jv\nPCbNynTtXVj8Iq42IAImdbqGRytZuGQNl0Cpvqsuz213pIx4en2WYqMEgqD7QlVQ\nebmHM9loOLLciSLQhYaqCq14YXQWBrjhBO61kAZ3diupb1tjyoFzFdhAWQKBgGFk\ntPeNTgGxG37FL9E+7JTPQDIW8BTqHqvk41ZIOc8P5FxV8qBgiVkdaG34zEWi22h5\nJO+2symTqbeerkfQgedArDgRknlYcRoCi53e6mCNuDKyrUaXutN/vSRYK2yiuu06\n7ADR4xJL6WLf0taOvb5JFLHsjQM1rcK67SuwPLDFAoGBAJcxG9W/CrJhL628uyEC\nZ1C4OjfT6OpeEl0NinWkFm1ohHWZfNCVRejMlmRwq6my8BV9l0D0pIoW3GLe6Vr6\nxFwGjPU7JShDAv9q/wefipz2NtnIS6+13M2XFpLjHg2/wLBNuoR0EVqB7bQ6FDjp\nyF21MnqG4yd6nnRlc72GZ3YD\n-----END PRIVATE KEY-----\n",
  "client_email": "dsheldon-sa-435@rancher-dev.iam.gserviceaccount.com",
  "client_id": "101051263399149667922",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/dsheldon-sa-435%40rancher-dev.iam.gserviceaccount.com"
}
)
  }
}

resource "rancher2_cluster" "gke" {
  name = "dan-gke"
  description = "Terraform GKE cluster"
  gke_config_v2 {
    name = "dan-gke"
    google_credential_secret = rancher2_cloud_credential.foo-google.id
    region = europe-west2 # Zone argument could also be used instead of region
    project_id = rancher-dev
    kubernetes_version = "1.21.6-gke.1500"
    network = sheldon-vpc-custom
    node_pools {
      initial_node_count = 1
      max_pods_constraint = 110
      name = dan-gke-node
    }
  }
}