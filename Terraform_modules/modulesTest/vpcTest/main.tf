provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"
  name = var.name
  cidr_block = "10.0.0.0/16"
  public_subnet_cidr = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidr = ["10.0.10.0/24", "10.0.11.0/24"]

  azs = ["us-east-1a", "us-east-1b"]
}