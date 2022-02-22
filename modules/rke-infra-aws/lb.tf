# Create network lb
resource "aws_lb" "rancher_lb" {
  count = var.deploy_lb ? 1 : 0

  name               = "${var.prefix}-rancher-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnets.available.ids

  tags = local.tags
}

# Create lb target group on port 80
resource "aws_lb_target_group" "rancher_lb_tg_80" {
  count = var.deploy_lb ? 1 : 0

  name     = "${var.prefix}-rancher-lb-tg-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    protocol = "HTTP"
    path = "/healthz"
    matcher = "200-399"
  }
  tags = local.tags
}

# Create lb target group on port 443
resource "aws_lb_target_group" "rancher_lb_tg_443" {
  count = var.deploy_lb ? 1 : 0

  name     = "${var.prefix}-rancher-lb-tg-443"
  port     = 443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    protocol = "HTTPS"
    path = "/healthz"
    matcher = "200-399"
  }
  tags = local.tags
}

# Create lb target group attachment on port 80 for node_all instances
resource "aws_lb_target_group_attachment" "rancher_lb_tg_attach_80_all" {
  count = var.deploy_lb ? var.node_all_count : 0

  target_group_arn = aws_lb_target_group.rancher_lb_tg_80[0].arn
  target_id        = aws_instance.node_all[count.index].id
  port             = aws_lb_target_group.rancher_lb_tg_80[0].port
}

# Create lb target group attachment on port 80 for node_worker instances
resource "aws_lb_target_group_attachment" "rancher_lb_tg_attach_80_worker" {
  count = var.deploy_lb ? var.node_worker_count : 0

  target_group_arn = aws_lb_target_group.rancher_lb_tg_80[0].arn
  target_id        = aws_instance.node_worker[count.index].id
  port             = aws_lb_target_group.rancher_lb_tg_80[0].port
}

# Create lb target group attachment on port 443 for node_all instances
resource "aws_lb_target_group_attachment" "rancher_lb_tg_attach_443_all" {
  count = var.deploy_lb ? var.node_all_count : 0

  target_group_arn = aws_lb_target_group.rancher_lb_tg_443[0].arn
  target_id        = aws_instance.node_all[count.index].id
  port             = aws_lb_target_group.rancher_lb_tg_443[0].port
}

# Create lb target group attachment on port 443 for node_worker instances
resource "aws_lb_target_group_attachment" "rancher_lb_tg_attach_443_worker" {
  count = var.deploy_lb ? var.node_worker_count : 0

  target_group_arn = aws_lb_target_group.rancher_lb_tg_443[0].arn
  target_id        = aws_instance.node_worker[count.index].id
  port             = aws_lb_target_group.rancher_lb_tg_443[0].port
}

# Create lb listener on port 80
resource "aws_lb_listener" "rancher_lb_listen_80" {
  count = var.deploy_lb ? 1 : 0

  load_balancer_arn = aws_lb.rancher_lb[count.index].arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rancher_lb_tg_80[count.index].arn
  }
}

# Create lb listener on port 443
resource "aws_lb_listener" "rancher_lb_listen_443" {
  count = var.deploy_lb ? 1 : 0

  load_balancer_arn = aws_lb.rancher_lb[count.index].arn
  port              = "443"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rancher_lb_tg_443[count.index].arn
  }
}