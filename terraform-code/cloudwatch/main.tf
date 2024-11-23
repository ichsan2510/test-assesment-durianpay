terraform {
  backend "s3" {}
}

provider "aws" {
  region = "ap-southeast-3" 
}

# Fetch existing EC2 instance by tag
data "aws_instance" "existing_instance" {
  filter {
    name   = "tag:Name"
    values = ["web-launch-template"] 
  }
}

# Enable Detailed Monitoring for EC2 Instance
resource "aws_instance_monitoring" "detailed_monitoring" {
  instance_id = data.aws_instance.existing_instance.id
}

# CloudWatch Alarm for CPU Usage
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "CPU_Usage_High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_actions = [] # Add actions such as SNS topics
  dimensions = {
    InstanceId = data.aws_instance.existing_instance.id
  }
}

# CloudWatch Alarm for Memory Usage
# This requires the CloudWatch Agent
resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "Memory_Usage_High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "CWAgent" 
  period              = 300
  statistic           = "Average"
  threshold           = 70 

  alarm_actions = [] # Add actions such as SNS topics
  dimensions = {
    InstanceId = data.aws_instance.existing_instance.id
  }
}

# CloudWatch Alarm for Status Check Failures
resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  alarm_name          = "Status_Check_Failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 1

  alarm_actions = [] # Add actions such as SNS topics
  dimensions = {
    InstanceId = data.aws_instance.existing_instance.id
  }
}

# CloudWatch Alarm for Network Usage
resource "aws_cloudwatch_metric_alarm" "network_in_high" {
  alarm_name          = "Network_In_High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Sum"
  threshold           = 50000000 # Replace with your threshold in bytes (50 MB)

  alarm_actions = [] # Add actions such as SNS topics
  dimensions = {
    InstanceId = data.aws_instance.existing_instance.id
  }
}

resource "aws_cloudwatch_metric_alarm" "network_out_high" {
  alarm_name          = "Network_Out_High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Sum"
  threshold           = 50000000 # Replace with your threshold in bytes (50 MB)

  alarm_actions = [] # Add actions such as SNS topics
  dimensions = {
    InstanceId = data.aws_instance.existing_instance.id
  }
}