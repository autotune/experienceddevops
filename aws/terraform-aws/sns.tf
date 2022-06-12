resource "aws_sns_topic" "asg" {
  name = "asg-web-${terraform.workspace}"
}

resource "aws_sns_topic_subscription" "primary" {
  topic_arn = aws_sns_topic.asg.arn
  protocol  = "sms"
  endpoint  = var.phone_number
}
