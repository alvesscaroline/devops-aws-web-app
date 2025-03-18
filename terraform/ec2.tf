# Create SSH key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "${path.module}/key-ec2.pem"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "key-ec2-devops"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name
  user_data              = file("${path.module}/user-data.sh")

  tags = {
    Name = "DevOps-Web-Server"
  }
}