

variable "cidr_block" {
  type = string
  default = "190.160.0.0/16"
  description = "VPC CIDR (string)"

  validation {
    condition = can(cidrnetmask(var.cidr_block))
    error_message = "The cidr_block must be a valid CIDR range, such as 10.0.0.0/16"
  }
}

variable "name" {
  type = string
  description = "VPC Name"
  default = "VPC_From_Terraform"
}

variable public_subnet_cidr {
  type = list(string)
  description = "List of public subnet CIDRs"
  default = [ "190.160.0.0/24" ]
}

variable "private_subnet_cidr" {
  type = list(string)
  description = "List of private subenet CIDRs"
  default = [ "190.160.1.0/24" ]
}

variable "azs" {
  type = list(string)
  description = "List of availability zones"
  default = [ "us-east-1a", "us-east-1b"]
}