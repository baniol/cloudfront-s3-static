output "cf_arn" {
  value = aws_cloudfront_distribution.static-distribution.arn
}

output "cf_domain" {
  value = aws_cloudfront_distribution.static-distribution.domain_name
}