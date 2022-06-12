data "digitalocean_domain" "default" {
  for_each = toset(var.domain_name)
  name = each.value
}

resource "digitalocean_record" "a_records" {
  for_each = toset(var.domain_name)
  domain = each.value 
  type   = "A"
  ttl = 60
  name   = "@"
  value  = digitalocean_loadbalancer.ingress_load_balancer.ip
  depends_on = [
    kubernetes_ingress.atlantis_cluster_ingress
  ]
}

resource "digitalocean_record" "atlantis" {
  for_each = toset(var.domain_name)
  domain = each.value
  type   = "A"
  ttl = 60
  name   = "terraform"
  value  = digitalocean_loadbalancer.ingress_load_balancer.ip
  depends_on = [
    kubernetes_ingress.atlantis_cluster_ingress
  ]
}

resource "digitalocean_record" "auth" {
  for_each = toset(var.domain_name)
  domain = each.value
  type   = "A"
  ttl = 60
  name   = "auth"
  value  = digitalocean_loadbalancer.ingress_load_balancer.ip
  depends_on = [
    kubernetes_ingress.atlantis_cluster_ingress
  ]
}

resource "digitalocean_record" "argocd" {
  for_each = toset(var.domain_name)
  domain = each.value
  type   = "A"
  ttl = 60
  name   = "argocd"
  value  = digitalocean_loadbalancer.ingress_load_balancer.ip
  depends_on = [
    kubernetes_ingress.atlantis_cluster_ingress
  ]
}
