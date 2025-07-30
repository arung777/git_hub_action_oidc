#enable_dns_support = false
#enable_dns_hostnames = false


resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
  enable_dns_support = false
  enable_dns_hostnames = false
  tags = {
    Name = var.vpc_tag_name
  }
}

resource "aws_subnet" "TerraformPublicSubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_tag
  }
}

resource "aws_subnet" "TerraformPrivateSubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.private_subnet_cidr
  tags = {
    Name = var.private_subnet_tag
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RouteTable" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = var.route_cidr_block
    gateway_id = aws_internet_gateway.igw.id
}
}

resource "aws_route_table_association" "PublicSubnetAssociation" {
  subnet_id      = aws_subnet.TerraformPublicSubnet.id
  route_table_id = aws_route_table.RouteTable.id
}

########## If we dont create the aws_route_table_association for the public subnet, the public subnet will not be able to access the internet.