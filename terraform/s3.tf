resource "aws_s3_bucket" "cloudwatch_logs" {
  bucket = "my-logs-cloudwatch-${random_id.suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "cloudwatch_logs_policy" {
  bucket = aws_s3_bucket.cloudwatch_logs.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "logs.${var.aws_region}.amazonaws.com"
        },
        Action = "s3:PutObject",
        Resource = "${aws_s3_bucket.cloudwatch_logs.arn}/*"
      }
    ]
  })
}

resource "random_id" "suffix" {
  byte_length = 8
}