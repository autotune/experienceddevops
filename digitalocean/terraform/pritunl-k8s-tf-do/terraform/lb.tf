resource "digitalocean_loadbalancer" "ingress_load_balancer" {
  name   = "${var.do_k8s_name}-lb"
  region = var.do_region
  size = "lb-small"
  algorithm = "round_robin"

  forwarding_rule {
    entry_port     = 80 
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"

  }

  lifecycle {
      ignore_changes = [
        forwarding_rule,
    ]
  }

  vpc_uuid = digitalocean_vpc.k8s.id 
}
