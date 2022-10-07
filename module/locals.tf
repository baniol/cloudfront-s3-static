resource "random_string" "random" {
  length  = 5
  special = false
}

locals {
  domain_name = format("%s.%s", var.subdomain_name, var.hosted_zone_name)
  suffix      = random_string.random.result
}