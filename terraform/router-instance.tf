#data "template_file" "router_repositories" {
#  template = file("cloud-init/repository.tpl")
#  count    = length(var.repositories)
#
#  vars = {
#    repository_url  = element(values(var.repositories), count.index)
#    repository_name = element(keys(var.repositories), count.index)
#  }
#}
#
#data "template_file" "router_register_scc" {
#  template = file("cloud-init/register-scc.tpl")
#  count    = var.caasp_registry_code == "" ? 0 : 1
#
#  vars = {
#    caasp_registry_code = var.caasp_registry_code
#  }
#}
#
#data "template_file" "router_register_rmt" {
#  template = file("cloud-init/register-rmt.tpl")
#  count    = var.rmt_server_name == "" ? 0 : 1
#
#  vars = {
#    rmt_server_name = var.rmt_server_name
#  }
#}
#
#data "template_file" "router_commands" {
#  template = file("cloud-init/router-commands.tpl")
#  count    = join("", var.router_only_packages) == "" ? 0 : 1
#
#  vars = {
#    packages = join(", ", var.router_only_packages)
#  }
#}
#
#
#data "template_file" "router-cloud-init" {
#  template = file("cloud-init/router-cloud-init.tpl")
#
#  vars = {
#    authorized_keys 	= join("\n", formatlist("  - %s", var.authorized_keys))
#    repositories    	= join("\n", data.template_file.router_repositories.*.rendered)
#    register_scc    	= join("\n", data.template_file.router_register_scc.*.rendered)
#    register_rmt    	= join("\n", data.template_file.router_register_rmt.*.rendered)
#    commands        	= join("\n", data.template_file.router_commands.*.rendered)
#    username        	= var.username
#    password        	= var.password
#    ntp_servers     	= join("\n", formatlist("    - %s", var.ntp_servers))
#  }
#}

resource "libvirt_volume" "router" {
  name           = "${var.stack_name}-router-volume-${count.index}"
  pool           = var.pool
  size           = var.router_disk_size
  base_volume_id = libvirt_volume.img.id
  count          = var.routers
}

#resource "libvirt_cloudinit_disk" "router" {
#  # needed when 0 router nodes are defined
#  count     = var.routers
#  name      = "${var.stack_name}-router-cloudinit-disk-${count.index}"
#  pool      = var.pool
#  user_data = data.template_file.router-cloud-init.rendered
#}

resource "libvirt_domain" "router" {
  count      = var.routers
  name       = "${var.stack_name}-router-domain-${count.index}"
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
    hostname       = "${var.stack_name}-router-${count.index}"
#    addresses      = [cidrhost(var.network_cidr, 256 + count.index)]
    mac            = "52:54:00:AB:A2:49"
    wait_for_lease = false
  }

  network_interface {
    network_id     = element(libvirt_network.inside-network.*.id, count.index)
    hostname       = "${var.stack_name}-inside-router-${count.index}"
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

