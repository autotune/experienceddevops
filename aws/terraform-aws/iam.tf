resource "aws_iam_role" "primary" {
  name = "${var.name}-primary"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "primary" {
  name = "${var.name}-primary"
  role = "${var.name}-primary"
}

resource "aws_iam_role_policy" "primary" {
  name = "${var.name}-primary"
  role = aws_iam_role.primary.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:DescribeTags"],
      "Resource": "*"
    }
  ]
}
EOF

}

