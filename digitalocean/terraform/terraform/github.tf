provider "github" {
  token        = var.github_token
}

data "github_ip_ranges" "default" {}

resource "random_id" "webhook" {
  byte_length = "64"
}

data "github_repository" "atlantis" {
  full_name = var.github_repo 
}

resource "github_repository_webhook" "hook" {
  repository = data.github_repository.atlantis.name
  for_each   = toset(var.domain_name)

  configuration {
    url          = "https://${each.value}/events"
    content_type = "application/json"
    insecure_ssl = false  
    secret       = random_id.webhook.hex
  }

  events = [
    "issue_comment",
    "pull_request",
    "pull_request_review",
    "pull_request_review_comment",
  ]

  lifecycle {
    # The secret is saved as ******* in the state
    ignore_changes = [configuration[0].secret]
  }
}

output "repository" {
  value = data.github_repository.atlantis.html_url
}
