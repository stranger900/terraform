#============ VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block #"10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "VPC"
  }
}

#============ Internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet gateway"
  }
}

#================= Elastic IamInstanceProfileName

resource "aws_eip" "eip1" {
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "eip2" {
  depends_on = [aws_internet_gateway.igw]
}

#==================== AWS NAT gateway

resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = var.subnet_public_1 #aws_subnet.public_1.id

  tags = {
    Name = "gw nat 1"
  }
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = var.subnet_public_2 #aws_subnet.public_2.id

  tags = {
    Name = "gw nat 2"
  }
}

#=============== AWS Route table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public"
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_1.id
  }

  tags = {
    Name = "Private-1"
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_2.id
  }

  tags = {
    Name = "Private-2"
  }
}

#=============== aws route table association

resource "aws_route_table_association" "public1" {
  subnet_id      = var.subnet_public_1 #aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = var.subnet_public_2 #aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = var.subnet_private_1 #aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = var.subnet_private_2 #aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}
