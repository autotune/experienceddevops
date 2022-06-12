# pritunl chart based off of https://github.com/articulate/helmcharts/tree/master/stable/pritunl

resource "kubernetes_namespace" "pritunl" {
  metadata {
    name = "pritunl"
  }
}

resource "helm_release" "pritunl" {
  depends_on = [kubernetes_namespace.pritunl, helm_release.mongodb, kubernetes_secret.docker_login_secret, kubernetes_secret.mongodb_root_password]

  name       = "pritunl"
  repository = "./helm_charts"
  chart      = "pritunl"
  namespace  = "pritunl"
  version    = "0.0.8" 

  values = [ data.template_file.pritunl.rendered ]
}
