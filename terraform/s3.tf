resource "aws_s3_bucket" "cloudwatch_logs" {
  bucket = var.bucket_cloudwatch
}

resource "aws_s3_bucket" "nginx_logs" {
  bucket = var.bucket_nginx
}