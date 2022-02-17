data "aws_route53_zone" "dns_zone" {
  count = var.route53_zone != "" ? 1 : 0

  name = var.route53_zone
}

resource "aws_route53_record" "rancher" {
  count = var.route53_zone != "" ? 1 : 0
  zone_id = data.aws_route53_zone.dns_zone[count.index].zone_id
  name    = "${var.route53_name}.${data.aws_route53_zone.dns_zone[count.index].name}"
  ttl     = "300"
  type    = var.deploy_lb ? "CNAME" : "A"
  records = var.deploy_lb ? [aws_lb.rancher_lb[count.index].dns_name] : flatten([[aws_instance.node_all[*].public_ip], [aws_instance.node_worker[*].public_ip]])
}