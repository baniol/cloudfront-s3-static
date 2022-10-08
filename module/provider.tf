provider "aws" {
  region = var.region
  # version = "~> 2.36.0"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}