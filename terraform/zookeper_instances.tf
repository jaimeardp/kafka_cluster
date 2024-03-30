
resource "aws_instance" "zookeeper_worker_z1" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name      = aws_key_pair.pub_key_kafka_brokers.key_name

  
  /*provisioner "file" {
    source      = tls_private_key.priv_key_kafka_brokers.public_key_openssh
    destination = "/home/ec2-user/.ssh/authorized_keys" 
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("my-terraform-key.pem")
      host        = self.private_ip
    }
  }*/

  subnet_id     = aws_subnet.subnet_private_cluster_az1.id


  vpc_security_group_ids      = [aws_security_group.kafka_cluster.id, aws_security_group.zookeeper.id]
  associate_public_ip_address = false

  root_block_device {
    volume_size = 50
  }

  depends_on = [aws_security_group.zookeeper]

  tags = {
    Name = "Worker-Zookeeper-AZ1"
  }
}

resource "aws_instance" "zookeeper_worker_z2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"
  key_name      = aws_key_pair.pub_key_kafka_brokers.key_name

  
  /*provisioner "file" {
    source      = tls_private_key.priv_key_kafka_brokers.public_key_openssh
    destination = "/home/ec2-user/.ssh/authorized_keys" 
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("my-terraform-key.pem")
      host        = self.private_ip
    }
  }*/

  subnet_id     = aws_subnet.subnet_private_cluster_az2.id


  vpc_security_group_ids      = [aws_security_group.kafka_cluster.id, aws_security_group.zookeeper.id]
  associate_public_ip_address = false

  root_block_device {
    volume_size = 50
  }

  depends_on = [aws_security_group.zookeeper]

  tags = {
    Name = "Worker-Zookeeper-AZ2"
  }
}

resource "aws_instance" "zookeeper_worker_z3" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  availability_zone = "us-east-1c"
  key_name      = aws_key_pair.pub_key_kafka_brokers.key_name

  
  /*provisioner "file" {
    source      = tls_private_key.priv_key_kafka_brokers.public_key_openssh
    destination = "/home/ec2-user/.ssh/authorized_keys" 
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("my-terraform-key.pem")
      host        = self.private_ip
    }
  }*/

  subnet_id     = aws_subnet.subnet_private_cluster_az3.id


  vpc_security_group_ids      = [aws_security_group.kafka_cluster.id, aws_security_group.zookeeper.id]
  associate_public_ip_address = false

  root_block_device {
    volume_size = 50
  }

  depends_on = [aws_security_group.zookeeper]

  tags = {
    Name = "Worker-Zookeeper-AZ3"
  }
}


######################
# Security Groups
######################

resource "aws_security_group" "zookeeper" {
  name        = "zookeeper-security-group"
  description = "Allow Zookeeper traffic for worker"
  vpc_id      = aws_vpc.vpc_kafka_cluster.id

  tags = {
    Name = "zookeeper-security-group"
  }
}

resource "aws_security_group_rule" "allow_zookeeper_quorum" {
  type                     = "ingress"
  from_port                = 2181
  to_port                  = 2181
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.kafka_cluster.id

  security_group_id = aws_security_group.zookeeper.id
}

resource "aws_security_group_rule" "allow_zookeeper_peers" {
  type      = "ingress"
  from_port = 2888
  to_port   = 2888
  protocol  = "tcp"
  self      = true

  security_group_id = aws_security_group.zookeeper.id
}

resource "aws_security_group_rule" "allow_zookeeper_leader_election" {
  type      = "ingress"
  from_port = 3888
  to_port   = 3888
  protocol  = "tcp"
  self      = true

  security_group_id = aws_security_group.zookeeper.id
}
