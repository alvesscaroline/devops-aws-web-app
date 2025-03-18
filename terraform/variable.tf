variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "security_group_name" {
  description = "Security Group Name"
  type        = string
  default     = "web_sg"
}

variable "bucket_cloudwatch" {
  description = "Bucket for CloudWatch logs"
  type        = string
  default     = "my-logs-cloudwatch-12345678"
}

variable "bucket_nginx" {
  description = "Bucket for Nginx logs"
  type        = string
  default     = "nginx-logs-12345678"
}