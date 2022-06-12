variable "enable_digitalocean" {
  description = "Enable / Disable Digital Ocean (e.g. `true`)"
  type        = bool
  default     = true
}

variable "random_cluster_suffix" {
  description = "Random 6 byte hex suffix for cluster name"
  type        = string
  default     = ""
}

variable "do_token" {
  description = "Digital Ocean Personal access token"
  type        = string
  default     = ""
}

variable "do_region" {
  description = "Digital Ocean region (e.g. `fra1` => Frankfurt)"
  type        = string
  default     = "nyc3"
}

variable "do_k8s_name" {
  description = "Digital Ocean Kubernetes cluster name (e.g. `k8s-do`)"
  type        = string
  default     = "k8s-do"
}

variable "do_k8s_pool_name" {
  description = "Digital Ocean Kubernetes default node pool name (e.g. `k8s-do-nodepool`)"
  type        = string
  default     = "k8s-mainpool"
}

variable "do_k8s_nodes" {
  description = "Digital Ocean Kubernetes default node pool size (e.g. `2`)"
  type        = number
  default     = 1
}

variable "do_k8s_node_type" {
  description = "Digital Ocean Kubernetes default node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "do_k8s_nodepool_name" {
  description = "Digital Ocean Kubernetes additional node pool name (e.g. `k8s-do-nodepool`)"
  type        = string
  default     = "k8s-nodepool"
}

variable "do_k8s_nodepool_type" {
  description = "Digital Ocean Kubernetes additional node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "do_k8s_nodepool_size" {
  description = "Digital Ocean Kubernetes additional node pool size (e.g. `3`)"
  type        = number
  default     = 2
}

variable "domain_name" {
  description = "domain to use for argo and atlantis"
  default     = ["wayofthesys.com"]
}

variable "atlantis_github_user" {
  description = "atlantis github user"
}

variable "atlantis_github_user_token" {
  description = "atlantis github user_token"
}

variable "letsencrypt_email" {
  description = "le email"
}

variable "atlantis_container" {
  type        = string
  default     = "runatlantis/atlantis:latest"

  description = "Name of the Atlantis container image to deploy."
}

variable "atlantis_repo_whitelist" {
  type    = string 
  default = "github.com/autotune/pritunl-k8s-tf-do"
}

variable "github_repo" {
  type = string
  default = "autotune/pritunl-k8s-tf-do"
}

variable "github_token" {
  type = string
}

variable "sslcom_keyid" {
  type = string
}

variable "sslcom_hmac_key" {
  type = string
} 

variable "sslcom_private_hmac_key" {
  type = string
} 

variable "oauth_client_id" {
  type = string
}

variable "oauth_client_secret" {
  type = string
}

variable "oauth_cookie_secret" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}

variable "package_registry_pat" {
  type = string
}

variable "gh_username" {
  type = string
} 
