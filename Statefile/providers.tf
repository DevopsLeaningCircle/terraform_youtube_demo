terraform {
  required_version = "~> 1.12"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }

  # S3 + DynamoDB
    # backend "s3" {
    #   bucket         = "devopslearningcircle-terraform-statefile"
    #   key            = "dev/terraform.tfstate"
    #   region         = "us-east-1"
    #   dynamodb_table = "terraform-locks"
    #   encrypt        = true
    # }

  # S3 + Native Locking
  backend "s3" {
    bucket         = "devopslearningcircle-terraform-statefile"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }


}

provider "aws" {
  region = "us-east-1"
}