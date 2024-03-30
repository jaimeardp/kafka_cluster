resource "aws_instance" "kafka_broker_az1" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.small"
  availability_zone = "us-east-1a"
  key_name      = aws_key_pair.pub_key_kafka_brokers.key_name
  subnet_id     = aws_subnet.subnet_public_cluster_az1.id
  vpc_security_group_ids      = [aws_security_group.kafka_cluster.id, aws_security_group.kafka.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 50
  }

  depends_on = [aws_security_group.kafka]

  tags = {
    Name = "Broker-AZ1"
  }
}

resource "aws_instance" "kafka_broker_az2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.small"
  availability_zone = "us-east-1b"
  key_name      = aws_key_pair.pub_key_kafka_brokers.key_name

  subnet_id     = aws_subnet.subnet_public_cluster_az2.id


  vpc_security_group_ids      = [aws_security_group.kafka_cluster.id, aws_security_group.kafka.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 50
  }

  depends_on = [aws_security_group.kafka]

  tags = {
    Name = "Broker-AZ2"
  }
}

resource "aws_instance" "kafka_broker_az3" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.small"
  availability_zone = "us-east-1c"
  key_name      = aws_key_pair.pub_key_kafka_brokers.key_name

  subnet_id     = aws_subnet.subnet_public_cluster_az3.id


  vpc_security_group_ids      = [aws_security_group.kafka_cluster.id, aws_security_group.kafka.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 50
  }

  depends_on = [aws_security_group.kafka]

  tags = {
    Name = "Broker-AZ3"
  }
}


resource "aws_security_group" "kafka_cluster" {
  name        = "kafka-cluster-security-group"
  description = "Allow kafka_cluster traffic"
  vpc_id      = aws_vpc.vpc_kafka_cluster.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group_rule" "allow_kafka_cluster_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.0.7.0/24", "10.0.8.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", "38.43.130.99/32"]
  security_group_id = "${aws_security_group.kafka_cluster.id}"
}

resource "aws_security_group_rule" "allow_kafka_cluster_telenet" {
  type        = "ingress"
  from_port   = 23
  to_port     = 23
  protocol    = "tcp"
  cidr_blocks = ["10.0.7.0/24", "10.0.8.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", "38.43.130.99/32"]
  security_group_id = "${aws_security_group.kafka_cluster.id}"
}

resource "aws_security_group_rule" "allow_kafka_cluster_self_ping" {
  type      = "ingress"
  from_port = 8
  to_port   = 0
  protocol  = "icmp"
  # self      = true
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kafka_cluster.id}"
}


resource "aws_security_group" "kafka" {
  name        = "kafka-security-group"
  description = "Allow kafka brokers traffic"
  vpc_id      = aws_vpc.vpc_kafka_cluster.id

}

resource "aws_security_group_rule" "allow_kafka_port_peers" {
  type      = "ingress"
  from_port = 9092
  to_port   = 9092
  protocol  = "tcp"
  self      = true

  security_group_id = "${aws_security_group.kafka.id}"
}

resource "aws_security_group_rule" "allow_kafka_port_local_kafka_cluster_sg" {
  type                     = "ingress"
  from_port                = 9092
  to_port                  = 9092
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.kafka_cluster.id

  security_group_id = "${aws_security_group.kafka.id}"
}

resource "aws_security_group_rule" "allow_kafka_port_local_ips" {
  type        = "ingress"
  from_port   = 9092
  to_port     = 9092
  protocol    = "tcp"
  cidr_blocks = ["10.0.7.0/24", "10.0.8.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  security_group_id = "${aws_security_group.kafka.id}"

  count = 1 // create the rule only if at least one local ip is specified
}

resource "aws_security_group_rule" "allow_kafka_port_external" {
  type        = "ingress"
  from_port   = 9093
  to_port     = 9093
  protocol    = "tcp"
  cidr_blocks = ["10.0.7.0/24", "10.0.8.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  security_group_id = "${aws_security_group.kafka.id}"
}

// create rule to instnces talking each other with public ip
resource "aws_security_group_rule" "allow_kafka_port_public_1" {
  type        = "ingress"
  from_port   = 9093
  to_port     = 9093
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.kafka.id}"
}

resource "aws_security_group_rule" "allow_kafka_port_public_2" {
  type        = "ingress"
  from_port   = 9092
  to_port     = 9092
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.kafka.id}"
}


resource "aws_security_group_rule" "allow_kafka_port_public_3" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.kafka.id}"
}
