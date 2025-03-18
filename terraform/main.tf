terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3" {
  source = "./s3.tf"
}

module "cloudwatch" {
  source = "./cloudwatch.tf"
}

module "ec2" {
  source = "./ec2.tf"
}