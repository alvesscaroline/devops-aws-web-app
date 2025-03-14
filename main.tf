provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "${path.module}/key-ec2.pem"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "key-ec2"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu Server 22.04 LTS for us-east-1
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name  

  tags = {
    Name = "DevOps-Web-Server"
  }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}