terraform {
  required_version = ">= 1.2.8"
}

provider "aws" {
  region = var.aws_region
}

module "security_group" {
  source = "./security-group.tf"
}

module "ec2" {
  source = "./ec2.tf"
}

module "s3" {
  source = "./s3.tf"
}

module "cloudwatch" {
  source = "./cloudwatch.tf"
}

module "outputs" {
  source = "./outputs.tf"
}