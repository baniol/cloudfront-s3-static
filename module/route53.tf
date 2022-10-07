data "aws_route53_zone" "main" {
  name         = format("%s.", var.hosted_zone_name)
  private_zone = false
}

resource "aws_route53_record" "static" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.subdomain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.static-distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

## Certificate

resource "aws_acm_certificate" "cert" {
  domain_name       = local.domain_name
  validation_method = "DNS"
  provider          = aws.virginia

  tags = {
    Name = local.domain_name
  }
}

resource "aws_route53_record" "cert_record" {
  provider = aws.virginia
  for_each = {
    for d in aws_acm_certificate.cert.domain_validation_options :
    d.domain_name => {
      name   = d.resource_record_name
      record = d.resource_record_value
      type   = d.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
  zone_id         = data.aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_record : record.fqdn]
  provider                = aws.virginia
}