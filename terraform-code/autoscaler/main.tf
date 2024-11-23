terraform {
  backend "s3" {}
}

provider "aws" {
  region = "ap-southeast-3" 
}

# Create a Launch Template
resource "aws_launch_template" "web" {
  name_prefix   = "web-launch-template"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t2.medium"

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "asg-instance"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "example" {
  desired_capacity     = 2
  min_size             = 2
  max_size             = 5
  vpc_zone_identifier  = [data.aws_subnet.private_subnet.id] # Use the private subnet

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# CloudWatch Metric for Scaling Policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.example.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.example.name
}

# CloudWatch Alarm for Scale-Up
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "CPU_Usage_High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 45

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }
}

# CloudWatch Alarm for Scale-Down
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "CPU_Usage_Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20

  alarm_actions = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }
}