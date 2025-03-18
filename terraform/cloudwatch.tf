resource "aws_cloudwatch_log_group" "nginx_logs" {
  name              = "nginx-access-logs"
  retention_in_days = 30
}

resource "aws_iam_role" "cloudwatch_role" {
  name = "cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_ssm_parameter" "cwagent_config" {
  name  = "/AmazonCloudWatch-agent/config"
  type  = "String"
  value = jsonencode({
    "agent": {
      "metrics_collection_interval": 60,
      "run_as_user": "cwagent"
    },
    "metrics": {
      "aggregation_dimensions": [["InstanceId"]],
      "append_dimensions": {
        "AutoScalingGroupName": "AutoScalingGroupName",
        "InstanceId": "InstanceId",
        "InstanceType": "InstanceType"
      },
      "metrics_collected": {
        "disk": {
          "measurement": ["used_percent"],
          "metrics_collection_interval": 60,
          "resources": ["*"]
        },
        "mem": {
          "measurement": ["mem_used_percent"],
          "metrics_collection_interval": 60
        },
        "cpu": {
          "measurement": ["cpu_usage_active"],
          "metrics_collection_interval": 60
        }
      }
    }
  })
}