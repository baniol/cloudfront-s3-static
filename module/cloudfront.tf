locals {
  s3_origin_id = "StaticCFOrigin"
}

resource "aws_cloudfront_origin_access_control" "static" {
  name                              = "static"
  description                       = "Static site policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "static-distribution" {
  depends_on = [aws_acm_certificate.cert]
  origin {
    domain_name              = aws_s3_bucket.static.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.static.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.cf-distribution-description
  default_root_object = "index.html"

  #   logging_config {
  #     include_cookies = false
  #     bucket          = "mylogs.s3.amazonaws.com"
  #     prefix          = "myprefix"
  #   }
  # must depend on cert !
  aliases = [local.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 900
    max_ttl                = 86400

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.static.arn
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  # tags = {
  #   Environment = "dev"
  # }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "aws_cloudfront_function" "static" {
  name    = format("RewriteDefaultIndexRequest-%s", local.suffix)
  runtime = "cloudfront-js-1.0"
  comment = "Rewrite index.html"
  publish = true
  code    = file("${path.module}/function.js")
}