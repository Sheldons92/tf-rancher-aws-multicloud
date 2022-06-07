# Create a new rancher2_bootstrap using bootstrap provider config
resource "rancher2_bootstrap" "admin" {
  provider   = rancher2.bootstrap
  password   = var.bootstrapPassword
  # current_password = var.bootstrapPassword
   initial_password = var.bootstrapPassword
  telemetry  = true
}

output   token_key {
  value =   rancher2_bootstrap.admin.token
}

output   api_url {
  value =   rancher2_bootstrap.admin.url
}



# # Create a new rancher2 Cloud Credential
# resource "rancher2_cloud_credential" "aws" {
#   depends_on = [rancher2_bootstrap.admin]
#   provider = rancher2.admin
#   name = "rancherpso_aws"
#   description = "Cloud credentials for RancherPSO space on AWS"
#   amazonec2_credential_config {
#     access_key = var.aws_access_key
#     secret_key = var.aws_secret_key
#   }
# }

# output "cloud_credential" {
#   value = rancher2_cloud_credential.aws.id
# }
