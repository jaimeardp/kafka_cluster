resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_kafka_cluster.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_gateway.id
  }

  tags = {
    Name = "PublicRouteTableforKafkaCluster"
  }
}

resource "aws_route_table_association" "public_route_table_association_az1" {
  subnet_id      = aws_subnet.subnet_public_cluster_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_az2" {
  subnet_id      = aws_subnet.subnet_public_cluster_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_az3" {
  subnet_id      = aws_subnet.subnet_public_cluster_az3.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_kafka_cluster.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "PrivateRouteTableforKafkaCluster"
  }
}

resource "aws_route_table_association" "private_route_table_association_az1" {
  subnet_id      = aws_subnet.subnet_private_cluster_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_az2" {
  subnet_id      = aws_subnet.subnet_private_cluster_az2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_az3" {
  subnet_id      = aws_subnet.subnet_private_cluster_az3.id
  route_table_id = aws_route_table.private_route_table.id
}