output "sg_group_ec2" {
  value = aws_security_group.ec2.id
}

output "sg_group_elb" {
  value = aws_security_group.elb.id
}

output "elb_dns" {
  value = module.elb_http.elb_dns_name
}

