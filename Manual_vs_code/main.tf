### VPC configuration

# Create VPC
resource "aws_vpc" "iac_vpc" {
  cidr_block = "176.0.0.0/16"

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