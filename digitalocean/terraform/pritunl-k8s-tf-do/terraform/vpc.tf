resource "digitalocean_vpc" "k8s" {
  name     = "k8s-network"
  region   = "nyc3"
  ip_range = "10.0.0.0/16"
}
