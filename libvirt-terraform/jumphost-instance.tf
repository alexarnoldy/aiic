data "template_file" "jumphost_repositories" {
  template = file("cloud-init/repository.tpl")
  count    = length(var.repositories)

  vars = {
    repository_url  = element(values(var.repositories), count.index)
    repository_name = element(keys(var.repositories), count.index)
  }
}

data "template_file" "jumphost_register_scc" {
  template = file("cloud-init/register-scc.tpl")
  count    = var.caasp_registry_code == "" ? 0 : 1

  vars = {
    caasp_registry_code = var.caasp_registry_code
  }
}

data "template_file" "jumphost_register_rmt" {
  template = file("cloud-init/register-rmt.tpl")
  count    = var.rmt_server_name == "" ? 0 : 1

  vars = {
    rmt_server_name = var.rmt_server_name
  }
}

data "template_file" "jumphost_commands" {
  template = file("cloud-init/jumphost-commands.tpl")
  count    = join("", var.jumphost_only_packages) == "" ? 0 : 1

  vars = {
    packages = join(", ", var.jumphost_only_packages)
  }
}


data "template_file" "jumphost-cloud-init" {
  template = file("cloud-init/jumphost-cloud-init.tpl")

  vars = {
    authorized_keys 	= join("\n", formatlist("  - %s", var.authorized_keys))
    repositories    	= join("\n", data.template_file.jumphost_repositories.*.rendered)
    register_scc    	= join("\n", data.template_file.jumphost_register_scc.*.rendered)
    register_rmt    	= join("\n", data.template_file.jumphost_register_rmt.*.rendered)
    commands        	= join("\n", data.template_file.jumphost_commands.*.rendered)
    username        	= var.username
    password        	= var.password
    ntp_servers     	= join("\n", formatlist("    - %s", var.ntp_servers))
  }
}

resource "libvirt_volume" "jumphost" {
  name           = "${var.company-project_name}-jumphost-volume-${count.index}"
  pool           = var.pool
  size           = var.jumphost_disk_size
  base_volume_id = libvirt_volume.img.id
  count          = var.jumphosts
}

resource "libvirt_cloudinit_disk" "jumphost" {
  # needed when 0 jumphost nodes are defined
  count     = var.jumphosts
  name      = "${var.company-project_name}-jumphost-cloudinit-disk-${count.index}"
  pool      = var.pool
  user_data = data.template_file.jumphost-cloud-init.rendered
}

resource "libvirt_domain" "jumphost" {
  count      = var.jumphosts
  name       = "${var.company-project_name}-jumphost-domain-${count.index}"
  memory     = var.jumphost_memory
  vcpu       = var.jumphost_vcpu
  cloudinit  = element(libvirt_cloudinit_disk.jumphost.*.id, count.index)
#  depends_on = [libvirt_domain.lb]

  cpu = {
    mode = "host-passthrough"
  }

  disk {
    volume_id = element(libvirt_volume.jumphost.*.id, count.index)
  }

#  network_interface {
#    network_id     = libvirt_network.network.id
#    hostname       = "${var.company-project_name}-jumphost-${count.index}"
#    addresses      = [cidrhost(var.network_cidr, 2 + count.index)]
#    wait_for_lease = true
#  }

  network_interface {
    network_id     = element(libvirt_network.inside-network.*.id, count.index)
    hostname       = "${var.company-project_name}-jumphost-${count.index}"
    addresses      = [cidrhost(var.network_cidr, 2 + count.index)]
    wait_for_lease = false
  }


  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}

#resource "null_resource" "jumphost_wait_cloudinit" {
#  depends_on = [libvirt_domain.jumphost]
#  count      = var.jumphosts
#
#  connection {
#    host = element(
#      libvirt_domain.jumphost.*.network_interface.0.addresses.0,
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
#resource "null_resource" "jumphost_reboot" {
#  depends_on = [null_resource.jumphost_wait_cloudinit]
#  count      = var.jumphosts
#
#  provisioner "local-exec" {
#    environment = {
#      user = var.username
#      host = element(
#        libvirt_domain.jumphost.*.network_interface.0.addresses.0,
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

