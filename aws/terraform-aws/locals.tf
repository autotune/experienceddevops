locals {
  bucket_name = var.bucket

  common_tags = {
    "Name"        = var.name
    "CostCenter"  = var.costcenter
    "Bucket"      = var.bucket
    "Key"         = var.key
    "Environment" = terraform.workspace
  }
}

