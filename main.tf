module "cf-s3-static" {
  source = "./module"

  hosted_zone_name = "shiftbits.net"
  bucket_name      = "baniol-static-mkdocs"
  subdomain_name   = "docs"
}