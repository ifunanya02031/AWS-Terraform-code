resource "aws_vpc" "vpc" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true #

  tags = { #naming
    Name = "${var.environment}-vpc"
  }
}

#Internet Gateway

resource "aws_internet_gateway" "internet_gateway" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

#Public Subnets

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet_az1" {

  vpc_id = aws_vpc.vpc.id

  cidr_block = var.public_subnet_az1_cidr #

  availability_zone = data.aws_availability_zones.available.names[0] #.names

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-az1"
  }
}

resource "aws_subnet" "public_subnet_az2" {

  vpc_id = aws_vpc.vpc.id

  cidr_block = var.public_subnet_az2_cidr #

  availability_zone = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-az2"
  }
}

#Private App Subnets

resource "aws_subnet" "private_app_subnet_az1" {

  vpc_id = aws_vpc.vpc.id

  cidr_block = var.private_app_subnet_az1_cidr #

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.environment}-private-app-subnet-az1"
  }
}

resource "aws_subnet" "private_app_subnet_az2" {

  vpc_id = aws_vpc.vpc.id

  cidr_block = var.private_app_subnet_az2_cidr #

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.environment}-private-app-subnet-az2"
  }
}

#Private Database Subnets

resource "aws_subnet" "private_data_subnet_az1" {

  vpc_id = aws_vpc.vpc.id

  cidr_block = var.private_data_subnet_az1_cidr #

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.environment}-private-data-subnet-az1"
  }
}

resource "aws_subnet" "private_data_subnet_az2" {

  vpc_id = aws_vpc.vpc.id

  cidr_block = var.private_data_subnet_az2_cidr #

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.environment}-private-data-subnet-az2"
  }
}

# Nat Gateway

resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-eip"
  }
}
