terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.83.1"
    }
  }

  backend "s3" {
    bucket         = "mfa-terraform-state-bucket"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "mfa"
  }
}

provider "aws" {
  region = "us-east-1"
}