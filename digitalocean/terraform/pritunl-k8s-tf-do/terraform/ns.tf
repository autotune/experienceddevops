resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}

resource "kubernetes_namespace" "oauth_proxy" {
  metadata {
    name = "oauth-proxy"
  }
}
