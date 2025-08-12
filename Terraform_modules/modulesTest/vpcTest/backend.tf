terraform {
  backend "s3" {
    bucket         = "devopslearningcircle-terraform-statefile"
    key            = "modulesTest/vpcTest/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
  }
}
