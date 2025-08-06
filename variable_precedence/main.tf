# Creating VPC
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.name
  }

}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.name}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  
  tags = {
    Name = "${var.name}-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "igw"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }

  tags = { Name = "public_rt"}
}

resource "aws_route_table_association" "public" {
  route_table_id =  aws_route_table.public_rt.id
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
}