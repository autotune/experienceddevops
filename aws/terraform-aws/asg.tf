// these settings configured to demonstrate auto scale behavior, not for production
resource "aws_autoscaling_group" "primary" {
  depends_on                = [aws_key_pair.briana]
  name                      = "web-${var.name}-${terraform.workspace}"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 10
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.primary.name
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  vpc_zone_identifier = module.vpc.public_subnets

  timeouts {
    delete = "15m"
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances",
  ]

  metrics_granularity = "1Minute"

  tags = [
    {
      key                 = "CostCenter"
      value               = var.costcenter
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = terraform.workspace
      propagate_at_launch = true
    },
    {
      key                 = "Bucket"
      value               = var.bucket
      propagate_at_launch = true
    },
    {
      key                 = "Key"
      value               = var.key
      propagate_at_launch = true
    },
  ]
}

resource "aws_autoscaling_policy" "web_policy_up" {
  name                   = "web_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.primary.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name          = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "50"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.primary.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_policy_up.arn]
}

resource "aws_autoscaling_policy" "web_policy_down" {
  name                   = "web_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.primary.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name          = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "40"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.primary.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_policy_down.arn]
}

resource "aws_launch_configuration" "primary" {
  /* omit name to allow terraform to auto generate
     and prevent "name already in use" error */

  image_id             = data.aws_ami.primary.id
  iam_instance_profile = aws_iam_instance_profile.primary.name
  instance_type        = var.asg_size
  key_name             = var.key_name
  security_groups      = [aws_security_group.ec2.id]
  user_data            = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "primary" {
  autoscaling_group_name = aws_autoscaling_group.primary.id
  elb                    = module.elb_http.elb_id
}

resource "aws_autoscaling_notification" "asg_actions" {
  group_names = [
    aws_autoscaling_group.primary.name,
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]

  topic_arn = aws_sns_topic.asg.arn
}

