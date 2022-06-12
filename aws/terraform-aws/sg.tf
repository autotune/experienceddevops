resource "aws_security_group" "ec2" {
  name        = "ec2-${var.name}-${terraform.workspace}"
  description = "ec2 elb security group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ec2_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2_ingress_elb_80" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2.id
  source_security_group_id = aws_security_group.elb.id
}

// only apply if more than placebo whitelist rule 
resource "aws_security_group_rule" "ec2_ingress_22" {
  count             = length(var.whitelist) - 1
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2.id
  cidr_blocks       = var.whitelist
}

resource "aws_security_group" "elb" {
  name        = "elb-${var.name}-${terraform.workspace}"
  description = "elb security group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "elb_ingress_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.elb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.elb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

