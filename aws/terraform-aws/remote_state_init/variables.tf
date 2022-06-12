variable "region" {
  default = "us-west-2"
}

variable "profile" {
  default = "default"
}

variable "bucket" {
  default = "badams-foo-us-west-2"
}

variable "name" {
  default = "badams"
}

variable "costcenter" {
  default = "foo@example.com"
}

variable "key" {
  description = "tfstate key name"
  default     = "dev.tfstate"
}

