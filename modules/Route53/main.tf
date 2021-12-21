resource "aws_route53_zone" "primary" {
  name = "npterraform.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.npterraform.com"
  type    = "A"
  ttl     = "300"
  records = [var.eip]
}