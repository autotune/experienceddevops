terraform {
  backend "s3" {
    bucket = "badams-foo-us-west-2"
    key    = "badams-dev.tf"
    region = "us-west-2"
  }
}

