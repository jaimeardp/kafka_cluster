

resource "tls_private_key" "priv_key_kafka_brokers" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "pub_key_kafka_brokers" {
  key_name   = "my-terraform-key"
  public_key = tls_private_key.priv_key_kafka_brokers.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
  // = tls_private_key.priv_key_kafka_brokers.private_key_pem
  content           = tls_private_key.priv_key_kafka_brokers.private_key_pem
  filename          = "my-terraform-key.pem"
}