/* not part of objectives but best practice
   to store state in external backend */
resource "aws_s3_bucket" "backend" {
  bucket = var.bucket
  acl    = "private"

  tags = merge(local.common_tags)
}

