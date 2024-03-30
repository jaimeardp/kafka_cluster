resource "aws_vpc" "vpc_kafka_cluster" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpckafkacluster"
  }
}

resource "aws_internet_gateway" "ig_gateway" {
  vpc_id = aws_vpc.vpc_kafka_cluster.id

  tags = {
    Name = "InternetGatewayforKafkaCluster"
  }
}



resource "aws_eip" "nat_eip_for_kafka_cluster" {
  tags = {
    Name = "NATGatewayEIPforKafkaCluster"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip_for_kafka_cluster.id
  subnet_id     = aws_subnet.subnet_public_cluster_az1.id

  tags = {
    Name = "NATGatewayforKafkaCluster"
  }
}