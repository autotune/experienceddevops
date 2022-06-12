variable "region" {
  default = "eu-west-3"
}


variable "profile" {
  default = "default"
}

variable "key_name" {
  default = "briana"
}

variable "bucket" {
  default = ""
}

variable "ami_name" {
  default = "amzn-ami-hvm*"
}

variable "ami_owner" {
  default = "amazon"
}

variable "name" {
  default = "foobar"
}

variable "costcenter" {
  default = "foo@example.com"
}

variable "environment" {
  default = "dev"
}

variable "key" {
  default = "null.tfstate"
}

variable "asg_size" {
  default = "t2.micro"
}

variable "phone_number" {
  description = "Used for getting auto scale alerts"
  default     = "+15555555555"
}

variable "whitelist" {
  description = "IPs to whitelist for ssh access"
  default     = ["127.0.0.1/32", "167.71.252.152/32"]
}

