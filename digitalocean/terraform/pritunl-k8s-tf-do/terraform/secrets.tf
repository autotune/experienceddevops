resource "random_string" "random" {
  length           = 16
  special          = true
}

resource "kubernetes_secret" "eab_hmac" {
  metadata {
    name      = "sslcom-hmac-key"
    namespace = "kube-system"
  }

  data = {
    secret = var.sslcom_hmac_key
  }

  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "oath_proxy_secret" {
  depends_on = [kubernetes_namespace.oauth_proxy]
  for_each = toset(var.domain_name)
  metadata {
    name      = "${replace(each.key, ".", "-")}-oauth-proxy-tls"
    namespace = "oauth-proxy"
  }

  data = {
      github-client-id = base64encode(var.oauth_client_id)
      github-client-secret: base64encode(var.oauth_client_secret)
      cookie-secret: "V1pBekJxd05PVjIrc1lrai9nSGdYZz09" 
  }

  type = "kubernetes.io/opaque"
}
