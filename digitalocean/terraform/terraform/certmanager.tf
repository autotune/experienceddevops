resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.0.1"
  namespace        = "kube-system"
  timeout          = 120
  depends_on = [
    kubernetes_ingress.atlantis_cluster_ingress,
  ]
  set {
    name  = "createCustomResource"
    value = "true"
  }
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "cluster-issuer" {
  name       = "cluster-issuer"
  chart      = "../helm_charts/cluster-issuer"
  namespace  = "kube-system"
  depends_on = [
    helm_release.cert-manager,
  ]
  set {
    name  = "letsencrypt_email"
    value = "${var.letsencrypt_email}"
  }
  set {
    name = "sslcom_keyid"
    value = "${var.sslcom_keyid}"
  }
  set {
    name  = "sslcom_private_hmac_key"
    value = "${var.sslcom_private_hmac_key}"
  }
}
