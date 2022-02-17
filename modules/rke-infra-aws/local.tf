locals {
  ssh_pub_file = var.ssh_pub_file != "" ? var.ssh_pub_file : "${var.ssh_key_file}.pub"
  user_data = var.user_data != "" ? var.user_data : <<-EOT
    #!/bin/bash -x

    curl -sL https://releases.rancher.com/install-docker/${var.docker_version}.sh | sh
    sudo usermod -aG docker ${var.node_username}
  EOT
  node_all_cloudinit = <<-EOT
    ${local.user_data}
    %{ if var.register_command != "" }"${var.register_command} --etcd --controlplane --worker"%{ endif }
  EOT
  node_master_cloudinit = <<-EOT
    ${local.user_data}
    %{ if var.register_command != "" }"${var.register_command} --etcd --controlplane"%{ endif }
  EOT
  node_worker_cloudinit = <<-EOT
    ${local.user_data}
    %{ if var.register_command != "" }"${var.register_command} --worker"%{ endif }
  EOT
  tags = {
    TFModule = "${var.prefix}"
  }
}