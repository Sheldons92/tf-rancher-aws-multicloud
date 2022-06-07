# AWS infrastructure resources

# Create Nodes
resource "aws_instance" "node_master" {
  count                       = var.node_master_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.rancher_key_pair.key_name
  iam_instance_profile        = var.iam_instance_profile
  vpc_security_group_ids      = [aws_security_group.rancher_nodes.id]
  subnet_id                   = element(tolist(data.aws_subnet_ids.available.ids), 0)
  associate_public_ip_address = true
  user_data                   = local.node_master_cloudinit
  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type = "ssh"
      host = self.public_ip
      user = var.node_username
    }
  }
  tags = {
    Name                                     = "${var.prefix}-node-worker-${count.index}"
    K8sRoles                                 = "controlplane,etcd"
    TFModule                                 = var.prefix
    "kubernetes.io/cluster/${var.clusterid}" = "owned"
    DoNotDelete = true
  }
}

resource "aws_instance" "node_worker" {
  count                       = var.node_worker_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.rancher_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.rancher_nodes.id]
  subnet_id                   = element(tolist(data.aws_subnet_ids.available.ids), 0)
  associate_public_ip_address = true
  user_data                   = local.node_worker_cloudinit
  iam_instance_profile        = var.iam_instance_profile
  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type = "ssh"
      host = self.public_ip
      user = var.node_username
    }
  }
  tags = {
    Name                                     = "${var.prefix}-node-worker-${count.index}"
    K8sRoles                                 = "worker"
    TFModule                                 = var.prefix
    "kubernetes.io/cluster/${var.clusterid}" = "owned"
    DoNotDelete = true
  }
}

resource "aws_instance" "node_all" {
  count                       = var.node_all_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.rancher_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.rancher_nodes.id]
  subnet_id                   = element(tolist(data.aws_subnet_ids.available.ids), 0)
  associate_public_ip_address = true
  user_data                   = local.node_all_cloudinit
  iam_instance_profile        = var.iam_instance_profile
  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type = "ssh"
      host = self.public_ip
      user = var.node_username
    }
  }
  tags = {
    Name                                     = "${var.prefix}-node-worker-${count.index}"
    K8sRoles                                 = "controlplane,etcd,worker"
    TFModule                                 = var.prefix
    "kubernetes.io/cluster/${var.clusterid}" = "owned"
    DoNotDelete = "true"
  }
}