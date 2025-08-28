terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


  owners = ["099720109477"]
}

data "aws_vpc" "default" {
  default = true
}
# Count

# resource "aws_instance" "using_count" {
#   count = 3
#   ami = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"

#   tags = {
#     Name = "using_count_${count.index}"
#   }
# }

# for each
# resource "aws_instance" "example" {
#         for_each      = {
#             dev  = "t2.micro"
#             prod = "t2.medium"
#         }

#         ami           = data.aws_ami.ubuntu.id
#         instance_type = each.value

#         tags = {
#             Name = each.key
#         }
#     }

# variable "ingress_rules" {
#         default = [
#             { port = 22,  protocol = "tcp" },
#             { port = 80,  protocol = "tcp" },
#             { port = 443, protocol = "tcp" }
#         ]
#     }

#     resource "aws_security_group" "example" {
#         name        = "example-sg"
#         description = "Security group with dynamic ingress rules"
#         vpc_id      = data.aws_vpc.default.id

#         dynamic "ingress" {
#             for_each = var.ingress_rules
#             content {
#                 from_port   = ingress.value.port
#                 to_port     = ingress.value.port
#                 protocol    = ingress.value.protocol
#                 cidr_blocks = ["0.0.0.0/0"]
#             }
#         }
#     }

# variable "env" {
#   type = string
#   default = "dev"
# }
# resource "aws_instance" "my_instance" {
  
#   ami = data.aws_ami.ubuntu.id
#   instance_type = var.env == "dev" ? "t2.micro" : "t2.large"
# }

variable "names" {
  type = list(string)
  default = [ "dev", "qa", "prod" ]
}

output "names" {
  value = [for n in var.names : upper(n)]
}

output "names_with_filter" {
  value = [for n in var.names : upper(n) if n != "qa"]
}