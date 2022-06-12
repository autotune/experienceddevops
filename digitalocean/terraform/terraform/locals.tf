locals {
  name      = "${var.do_k8s_name}"
  extra_ips = ["10.0.0.0/16"]
  gh_ips    = [join(",", ([
    for h in data.github_ip_ranges.default.hooks : h if length(split(":", h)) == 1
  ]))]
}
