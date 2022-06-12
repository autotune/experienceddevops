variable "argocd_helm_chart_version" {
  type    = string
  default = "3.13.0"
}

variable "oauth_client_id" {
  type = string
}

variable "oauth_client_secret" {
  type = string
}

variable "argocd_server_host" {
  type    = string
}

variable "argocd_ingress_enabled" {
  type    = string
  default = "true"
}

variable "argocd_ingress_tls_acme_enabled" {
  type    = string
  default = "true"
}

variable "argocd_ingress_ssl_passthrough_enabled" {
  type    = string
  default = "true"
}

variable "argocd_ingress_class" {
  type    = string
  default = "true"
}

variable "argocd_ingress_tls_secret_name" {
  type    = string
  default = "argocd-cert"
}

variable "do_token" {
  type    = string
}

variable "do_k8s_name" {
  description = "Digital Ocean Kubernetes cluster name (e.g. `k8s-do`)"
  type        = string
  default     = "k8s-do"
}

variable "domain_name" {
  type = string  
}

variable "mongodb_version" {
  type = string
  default = "11.1.1"
}

variable "package_registry_pat" {
  type = string
}

variable "gh_username" {
  type = string
}

variable "mongodb_root_password" {
  type = string 
}

