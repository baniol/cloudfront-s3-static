# Require TF version to be same as or greater than 0.12.13
terraform {
  # required_version = ">=0.12.13"
  backend "s3" {
    bucket         = "terraform-backend-baniol"
    key            = "mkdocs-template/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks-baniol"
    encrypt        = true
  }
}
