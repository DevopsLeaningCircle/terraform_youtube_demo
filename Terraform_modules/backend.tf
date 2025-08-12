terraform {
    backend "s3" {
        bucket = "devopslearningcircle-terraform-statefile"
        key = terraform/moduleTest/state.tfstate
        region = "us-east-1"
        use_lockfile = true
    }
}
