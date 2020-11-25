resource "libvirt_network" "outside-network" {
  count  = var.network_name == "" ? 1 : 0
  name   = "${var.company-project_name}-outside-network"
  bridge = var.outside_bridge
  mode   = var.network_mode
}

resource "libvirt_network" "inside-network" {
  count  = var.network_name == "" ? 1 : 0
  name   = "${var.company-project_name}-inside-network"
  bridge = var.inside_bridge
  mode   = var.network_mode
}

