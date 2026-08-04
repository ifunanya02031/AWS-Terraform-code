resource "aws_nat_gateway" "nat_gateway" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_subnet_az1.id

  depends_on = [ #the creation of igw first
    aws_internet_gateway.internet_gateway
  ]

  tags = {
    Name = "${var.environment}-nat-gateway"
  }
}

# Public Route Table

resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

# Private Route Table

resource "aws_route_table" "private_route_table" {

  vpc_id = aws_vpc.vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat_gateway.id #attached
  }

  tags = {
    Name = "${var.environment}-private-rt"
  }
}

# Public Subnet (public) RT Associations

resource "aws_route_table_association" "public_subnet_az1_rt_association" {

  subnet_id = aws_subnet.public_subnet_az1.id

  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az2_rt_association" {

  subnet_id = aws_subnet.public_subnet_az2.id

  route_table_id = aws_route_table.public_route_table.id
}

# Private Subnet (private) RT Associations

resource "aws_route_table_association" "private_app_subnet_az1_rt_association" {

  subnet_id = aws_subnet.private_app_subnet_az1.id

  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_app_subnet_az2_rt_association" {

  subnet_id = aws_subnet.private_app_subnet_az2.id

  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_data_subnet_az1_rt_association" {

  subnet_id = aws_subnet.private_data_subnet_az1.id

  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_data_subnet_az2_rt_association" {

  subnet_id = aws_subnet.private_data_subnet_az2.id

  route_table_id = aws_route_table.private_route_table.id
}