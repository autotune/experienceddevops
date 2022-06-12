data "template_file" "pritunl" {
  template = file("${path.module}/pritunl/values.yaml.tpl")
  vars = {
    DOMAIN_NAME     = replace(var.domain_name, ".", "-")
    DOCKER_REPO     = "${var.gh_username}/pritunl-k8s-tf-do"
    DOCKER_TAG      = "pritunl:dc7700e4"
    DOCKER_REGISTRY = "ghcr.io"
  }
}

data "template_file" "docker_registry" {
  template = "${path.module}/docker/values.yaml.tpl"

  vars ={ 
    docker_secret_encoded = local.docker_secret_encoded
  }
}

data "template_file" "mongodb" {
  template = file("${path.module}/mongodb/values.yaml.tpl")

  vars ={ 
    ROOTPASSWORD = var.mongodb_root_password
  }
}

data "digitalocean_kubernetes_cluster" "k8s" {
  name = local.name
}

provider "kubernetes" {
  host                   = data.digitalocean_kubernetes_cluster.k8s.endpoint
  token                  = data.digitalocean_kubernetes_cluster.k8s.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host                   = data.digitalocean_kubernetes_cluster.k8s.endpoint
    token                  = data.digitalocean_kubernetes_cluster.k8s.kube_config[0].token

    cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
    )
  }
}

data "digitalocean_loadbalancer" "default" {
  name = "${var.do_k8s_name}-lb"
}
