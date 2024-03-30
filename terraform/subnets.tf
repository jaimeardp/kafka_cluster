# Public Subnet in AZ 1

resource "aws_subnet" "subnet_public_cluster_az1" {
  vpc_id            = aws_vpc.vpc_kafka_cluster.id
  cidr_block        = "10.0.7.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "PublicSubnetforKafkaCluster-AZ1"
  }
}

resource "aws_subnet" "subnet_private_cluster_az1" {
  vpc_id            = aws_vpc.vpc_kafka_cluster.id
  cidr_block        = "10.0.8.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1a"

  tags = {
    Name = "PrivateSubnetforKafkaCluster-AZ1"
  }
}

# Public Subnet in AZ 2
resource "aws_subnet" "subnet_public_cluster_az2" {
  vpc_id            = aws_vpc.vpc_kafka_cluster.id
  cidr_block        = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "PublicSubnetforKafkaCluster-AZ2"
  }
}

# Public Subnet in AZ 3
resource "aws_subnet" "subnet_public_cluster_az3" {
  vpc_id            = aws_vpc.vpc_kafka_cluster.id
  cidr_block        = "10.0.4.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1c"

  tags = {
    Name = "PublicSubnetforKafkaCluster-AZ3"
  }
}

# Private Subnet in AZ 2
resource "aws_subnet" "subnet_private_cluster_az2" {
  vpc_id            = aws_vpc.vpc_kafka_cluster.id
  cidr_block        = "10.0.5.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1b"

  tags = {
    Name = "PrivateSubnetforKafkaCluster-AZ2"
  }
}

# Private Subnet in AZ 3
resource "aws_subnet" "subnet_private_cluster_az3" {
  vpc_id            = aws_vpc.vpc_kafka_cluster.id
  cidr_block        = "10.0.6.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1c"

  tags = {
    Name = "PrivateSubnetforKafkaCluster-AZ3"
  }
}