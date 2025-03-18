resource "aws_cloudwatch_log_group" "nginx" {
  name              = "/nginx/access.log"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "nginx" {
  name           = "nginx-access-stream"
  log_group_name = aws_cloudwatch_log_group.nginx.name
}

resource "aws_s3_bucket" "nginx_logs" {
  bucket = "nginx-access-logs-storage-${random_id.suffix.hex}"
  force_destroy = true
}

resource "aws_cloudwatch_log_subscription_filter" "s3_export" {
  name            = "nginx-log-export"
  log_group_name  = aws_cloudwatch_log_group.nginx.name
  filter_pattern  = ""
  destination_arn = aws_s3_bucket.nginx_logs.arn
}