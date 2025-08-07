variable "vpc_name" {
   type = string
   default = "vpc_from_terraform"
}

variable "vpc_cidr_block" {
  type = string
  default = "176.0.0.0/16"
}

variable "public_subnet_name" {
  type = string
  default = "public_subnet"
}

variable "public_subnet_cidr" {
  type = string
  default = "176.0.1.0/24"
}
variable "private_subnet_name" {
  type = string
  default = "private_subnet"
}
variable "private_subnet_cidr" {
  type = string
  default = "176.0.100.0/24"
}

variable "igw_name" {
  type = string
  default = "igw_from_terraform"
}

variable "public_rt_name" {
  type = string
  default = "public_rt"
}