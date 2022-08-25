#Networking main

#---networking main

data "aws_availability_zone" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input = data.aws_availability_zone.availability.names
  result_count = var.max_subnets
}

resource "aws_vpc" "huy_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = "huy_vpc-${random_integer.random.id}"
  }
}

resource "aws_subnet" "huy_public_subnet" {
  count = var.public_sn_count
  vpc_id = aws_vpc.huy_vpc.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = random_shuffle.az_list.result[count.index]
  tags = {
    "Name" = "huy_public_${count.index+1}"
  }
}

resource "aws_route_table_association" "huy_rta" {
 #every public subnet will be associate with route table
  count = var.public_sn_count
  subnet_id = aws_subnet.huy_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.huy_public_rt.id

}

resource "aws_subnet" "huy_private_subnet" {
  count = var.private_sn_count
  vpc_id = aws_vpc.huy_vpc.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    "Name" = "huy_private_${count.index+1}"
  }
}

resource "aws_internet_gateway" "huy_ig" {
  vpc_id = aws_vpc.huy_vpc.id

  tags ={
    Name = "huy_igw"
  }
}

resource "aws_route_table" "huy_public_rt" {
  vpc_id = aws_vpc.huy_vpc.id
  tags = {
    "Name" = "huy_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id = aws_route_table.huy_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.huy_ig.id
}

resource "aws_default_route_table" "huy_private_rt" {
    default_route_table_id = aws_vpc.huy_vpc.default_route_table_id
  
    tags = {
      "Name" = "huy_private"
    }
}


resource "aws_security_group" "huy_sg"{
  name = "public_sg"
  description = "Security group for public access"
  vpc_id = aws_vpc.huy_vpc.id
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.access_ip]
  }
  egress{
    from_port = 0
    to_port = 0
    #protocol -1 is basically all protocols
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "huy_rds_subnetgroup"{
  name = "huy_rds_subnetgroup"
  subnet_ids = aws_subnet.huy_private_subnet.*.id
  tags{
    Name = "huy_rds_subnetgroup"
}
