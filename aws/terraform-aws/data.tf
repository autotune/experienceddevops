data "aws_ami" "primary" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  owners = [var.ami_owner]
}

data "template_file" "user_data" {
  template = file("templates/user_data.sh")
  vars     = {}
}

