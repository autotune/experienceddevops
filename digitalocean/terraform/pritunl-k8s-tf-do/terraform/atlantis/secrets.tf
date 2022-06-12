resource "kubernetes_secret" "docker_login_secret" {
  metadata {
    name      = "${replace(var.domain_name, ".", "-")}-docker-login"
    namespace = "pritunl"
  }

  data = {
      ".dockerconfigjson": <<EOF
{
  "auths": {
    "ghcr.io": {
      "auth": "${local.docker_secret_encoded}"
    }
  }
}
EOF
  }
  type = "kubernetes.io/dockerconfigjson" 
}

resource "kubernetes_secret" "mongodb_root_password" {
  metadata {
    name      = "mongodb-root-password"
    namespace = "pritunl"
  }

  data = {
    MONGODB_ROOT_PASSWORD = var.mongodb_root_password
  }

  type = "kubernetes.io/Opaque"
}

