variable "vpc_name" {
  default = "VPC_from_terraform"
}

variable "vpc_cidr" {
  default = "176.0.0.0/16"
}

variable "public_subnet_name" {
  default = "public_subnet"
}

variable "public_subnet_cidr" {
  default = "176.0.1.0/24"
}

variable "private_subnet_name" {
  default = "private_subnet"
}

variable "private_subnet_cidr" {
  default = "176.0.100.0/24"
}

variable "igw_name" {
  default = "igw_from_terraform"
}

variable "public_rt_name" {
  default = "rt_from_terrafrom"
}