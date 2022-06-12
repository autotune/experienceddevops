// ELB to be used to register web service instances
module "elb_http" {
  source = "terraform-aws-modules/elb/aws"

  name = "${var.name}-pub-${terraform.workspace}"

  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.elb.id]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
  ]

  health_check = {
    target              = "TCP:80"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  tags = merge(local.common_tags)
}

