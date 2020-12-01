#resource "libvirt_network" "inside-network" {
#  name   = "${var.company-project_name}-network"
#  mode   = var.network_mode
#  domain = var.dns_domain
#
#  dns {
#    enabled = true
#  }
#
#  addresses = [var.network_cidr]
#}

resource "libvirt_network" "inside-network" {
  count  = var.network_name == "" ? 1 : 0
  name   = "${var.company-project_name}-inside-network"
  bridge = var.inside_bridge
  mode   = var.network_mode
}



