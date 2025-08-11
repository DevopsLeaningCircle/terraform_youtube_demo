### VPC configuration

# Create VPC
resource "aws_vpc" "iac_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}
# Public  subnet inside VPC
resource "aws_subnet" "iac_public" {
  vpc_id = aws_vpc.iac_vpc.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name =  var.public_subnet_name
  }
}
# Private  subnet inside VPC
resource "aws_subnet" "iac_private" {
  vpc_id = aws_vpc.iac_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = var.private_subnet_name
  }

}
# Internet gateway to access internet in public subnet
resource "aws_internet_gateway" "iac_igw" {
  vpc_id = aws_vpc.iac_vpc.id
  tags = {
    Name = var.igw_name
  }
}

# Create route table
resource "aws_route_table" "iac_public_rt" {
  vpc_id = aws_vpc.iac_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac_igw.id
  }

  tags = {
    Name = var.public_rt_name
  }
}

# Assign route table in public subnet
resource "aws_route_table_association" "iac_rta_public" {
  route_table_id = aws_route_table.iac_public_rt.id
  subnet_id = aws_subnet.iac_public.id
}

# Create a security group
resource "aws_security_group" "iac_sg" {
    name = "iac_sg_ssh"
    description = "Allow ssh communication"
    vpc_id = aws_vpc.iac_vpc.id
}

resource "aws_security_group_rule" "allow_ssh" {
  
  security_group_id = aws_security_group.iac_sg.id
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  description = "Allow SSH"
  cidr_blocks = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "allow_http" {
  security_group_id = aws_security_group.iac_sg.id
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  description = "Allow HTTP"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all" {
  security_group_id = aws_security_group.iac_sg.id
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow all outbound traffic"
}

### Key pair
resource "tls_private_key" "key_rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "iac_key" {
  key_name = "iac_key"
  public_key = tls_private_key.key_rsa.public_key_openssh
}

resource "local_file" "local_iac_key" {
  content = tls_private_key.key_rsa.private_key_pem
  filename = "${path.cwd}/iac_key.pem"
}
### EC2 Creation

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "iac_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "iac_key"
  vpc_security_group_ids = [aws_security_group.iac_sg.id]
  subnet_id = aws_subnet.iac_public.id

  associate_public_ip_address = true

# Go for default what comes with free tier
#   root_block_device {
#     volume_size = 20
#     volume_type = "gp3"
#     encrypted   = true
#   }

  tags = {
    Name =  "iac-jankin-as-a-code"
  }
}