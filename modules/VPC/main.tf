# Contain all the resources

################ vpc ################
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "np-terraform-vpc"
  }
}

################ public subnets ################
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.subnet_az[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "np-terraform-subnet-public-${count.index + 1}"
  }
}

################ private subnets ################
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.subnet_az[count.index]
  tags = {
    Name = "np-terraform-subnet-private-${count.index + 1}"
  }
}

################ Internet Gateway ################
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "np-terraform-InternetGateway"
  }
}

################ Nat Gateway ################
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.Igw]
  tags = {
    Name = "np-terraform-eip"
  }
}
resource "aws_nat_gateway" "Ngw" {
  connectivity_type = "public"
  allocation_id     = aws_eip.nat_eip.id
  subnet_id         = aws_subnet.public_subnets[0].id
  tags = {
    Name = "np-terraform-NatGateway"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Igw]
}

################ Public Route table ################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw.id
  }
  tags = {
    Name = "np-terraform-publicRT"
  }
}
resource "aws_route_table_association" "public_subnets" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

################ Private Route table ################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Ngw.id
  }
  tags = {
    Name = "np-terraform-privateRT"
  }
}
resource "aws_route_table_association" "private_subnets" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}
