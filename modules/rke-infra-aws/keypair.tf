# Temporary key pair used for SSH accesss
resource "aws_key_pair" "rancher_key_pair" {
  key_name_prefix = "${var.prefix}-"
  public_key      = file(local.ssh_pub_file)
  tags = local.tags
}