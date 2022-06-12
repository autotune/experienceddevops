terraform {
  backend "s3" {
    endpoint                    = "nyc3.digitaloceanspaces.com"
    key                         = "atlantis.tfstate"
    bucket                      = "badams"
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
