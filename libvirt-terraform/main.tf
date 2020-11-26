provider "libvirt" {
#  uri = var.libvirt_keyfile == "" ? var.libvirt_uri : "${var.libvirt_uri}?keyfile=${var.libvirt_keyfile}"
#  uri = var.libvirt_keyfile == "" ? var.libvirt_uri : "${var.libvirt_host_base}${var.libvirt_host_number}?keyfile=${var.libvirt_keyfile}"
#  uri = "qemu+ssh://${var.libvirt_host_base}${var.libvirt_host_number}/system"
  uri = "qemu+ssh://${var.libvirt_user}@${var.libvirt_hostname}/system"

}

resource "libvirt_volume" "img" {
  name   = "${var.stack_name}-${basename(var.image_uri)}"
  source = var.image_uri
  pool   = var.pool
}

