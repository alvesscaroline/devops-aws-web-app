resource "aws_iam_role" "cw_agent_role" {
  name = "CloudWatchAgentRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cw_logs" {
  role       = aws_iam_role.cw_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "cw_agent_profile" {
  name = "CloudWatchAgentProfile"
  role = aws_iam_role.cw_agent_role.name
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu Server 22.04 LTS
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.cw_agent_profile.name
  key_name               = aws_key_pair.ec2_key.key_name  

  tags = {
    Name = "DevOps-Web-Server"
  }
}