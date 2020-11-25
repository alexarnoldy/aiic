
resource "libvirt_volume" "router" {
  name           = "${var.company-project_name}-router-volume-${count.index}"
  pool           = var.pool
  size           = var.router_disk_size
  base_volume_id = libvirt_volume.img.id
  count          = var.routers
}

#resource "libvirt_cloudinit_disk" "router" {
#  # needed when 0 router nodes are defined
#  count     = var.routers
#  name      = "${var.company-project_name}-router-cloudinit-disk-${count.index}"
#  pool      = var.pool
#  user_data = data.template_file.router-cloud-init.rendered
#}

resource "libvirt_domain" "router" {
  count      = var.routers
  name       = "${var.company-project_name}-${var.inside_bridge}-router-${count.index}"
  memory     = var.router_memory
  vcpu       = var.router_vcpu
#  cloudinit  = element(libvirt_cloudinit_disk.router.*.id, count.index)
#  depends_on = [libvirt_domain.lb]

  cpu = {
    mode = "host-passthrough"
  }

  disk {
    volume_id = element(libvirt_volume.router.*.id, count.index)
  }

  network_interface {
    network_id     = element(libvirt_network.outside-network.*.id, count.index)
    hostname       = "${var.company-project_name}-router-${count.index}"
#    addresses      = [cidrhost(var.network_cidr, 256 + count.index)]
    mac            = "52:54:00:AB:A2:49"
    wait_for_lease = false
  }

  network_interface {
    network_id     = element(libvirt_network.inside-network.*.id, count.index)
    hostname       = "${var.company-project_name}-inside-router-${count.index}"
#    addresses      = [cidrhost(var.network_cidr, 256 + count.index)]
    wait_for_lease = false
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}

#resource "null_resource" "router_wait_cloudinit" {
#  depends_on = [libvirt_domain.router]
#  count      = var.routers
#
#  connection {
#    host = element(
#      libvirt_domain.router.*.network_interface.0.addresses.0,
#      count.index,
#    )
#    user     = var.username
#    password = var.password
#    type     = "ssh"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "cloud-init status --wait > /dev/null",
#    ]
#  }
#}
#
#resource "null_resource" "router_reboot" {
#  depends_on = [null_resource.router_wait_cloudinit]
#  count      = var.routers
#
#  provisioner "local-exec" {
#    environment = {
#      user = var.username
#      host = element(
#        libvirt_domain.router.*.network_interface.0.addresses.0,
#        count.index,
#      )
#    }
#
#    command = <<EOT
#ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $user@$host sudo reboot || :
## wait for ssh ready after reboot
#until nc -zv $host 22; do sleep 5; done
#ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -oConnectionAttempts=60 $user@$host /usr/bin/true
#EOT
#
#  }
#}

