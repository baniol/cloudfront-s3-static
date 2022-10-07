provider "aws" {
  region = "eu-central-1"
  # version = "~> 2.36.0"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}