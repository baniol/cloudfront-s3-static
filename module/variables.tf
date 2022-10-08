variable "cf-distribution-description" {
  type        = string
  default     = "Serve static content from S3"
  description = "Description of the CF distribution"
}

variable "bucket_name" {
  type = string
}

variable "hosted_zone_name" {
  type = string
}

variable "subdomain_name" {
  type = string
}

variable "region" {
  type = string
  default = "eu-central-1"
}