data "template_file" "primary_repositories" {
  template = file("cloud-init/repository.tpl")
  count    = length(var.repositories)

  vars = {
    repository_url  = element(values(var.repositories), count.index)
    repository_name = element(keys(var.repositories), count.index)
  }
}

data "template_file" "primary_register_scc" {
  template = file("cloud-init/register-scc.tpl")
  count    = var.caasp_registry_code == "" ? 0 : 1

  vars = {
    caasp_registry_code = var.caasp_registry_code
  }
}

data "template_file" "primary_register_rmt" {
  template = file("cloud-init/register-rmt.tpl")
  count    = var.rmt_server_name == "" ? 0 : 1

  vars = {
    rmt_server_name = var.rmt_server_name
  }
}

data "template_file" "primary_commands" {
  template = file("cloud-init/commands.tpl")
  count    = join("", var.packages) == "" ? 0 : 1

  vars = {
    packages = join(", ", var.packages)
  }
}

data "template_file" "primary-cloud-init" {
  template = file("cloud-init/common.tpl")

  vars = {
    authorized_keys = join("\n", formatlist("  - %s", var.authorized_keys))
    repositories    = join("\n", data.template_file.primary_repositories.*.rendered)
    register_scc    = join("\n", data.template_file.primary_register_scc.*.rendered)
    register_rmt    = join("\n", data.template_file.primary_register_rmt.*.rendered)
    commands        = join("\n", data.template_file.primary_commands.*.rendered)
    username        = var.username
    password        = var.password
    ntp_servers     = join("\n", formatlist("    - %s", var.ntp_servers))
  }
}

resource "libvirt_volume" "primary" {
  name           = "${var.company-project_name}-primary-volume-${count.index}"
  pool           = var.pool
  size           = var.primary_disk_size
  base_volume_id = libvirt_volume.img.id
  count          = var.primarys
}

resource "libvirt_cloudinit_disk" "primary" {
  # needed when 0 primary nodes are defined
  count     = var.primarys
  name      = "${var.company-project_name}-primary-cloudinit-disk-${count.index}"
  pool      = var.pool
  user_data = data.template_file.primary-cloud-init.rendered
}

resource "libvirt_domain" "primary" {
  count      = var.primarys
  name       = "${var.company-project_name}-primary-domain-${count.index}"
  memory     = var.primary_memory
  vcpu       = var.primary_vcpu
  cloudinit  = element(libvirt_cloudinit_disk.primary.*.id, count.index)
#  depends_on = [libvirt_domain.lb]

  cpu = {
    mode = "host-passthrough"
  }

  disk {
    volume_id = element(libvirt_volume.primary.*.id, count.index)
  }

#  network_interface {
#    network_id     = libvirt_network.network.id
#    hostname       = "${var.company-project_name}-primary-${count.index}"
#    addresses      = [cidrhost(var.network_cidr, 256 + count.index)]
#    wait_for_lease = true
#  }

  network_interface {
    network_id     = element(libvirt_network.inside-network.*.id, count.index)
    hostname       = "${var.company-project_name}-inside-primary-${count.index}"
    addresses      = [cidrhost(var.network_cidr, 256 + count.index)]
    wait_for_lease = false
  }



  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}

#resource "null_resource" "primary_wait_cloudinit" {
#  depends_on = [libvirt_domain.primary]
#  count      = var.primarys
#
#  connection {
#    host = element(
#      libvirt_domain.primary.*.network_interface.0.addresses.0,
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
#resource "null_resource" "primary_reboot" {
#  depends_on = [null_resource.primary_wait_cloudinit]
#  count      = var.primarys
#
#  provisioner "local-exec" {
#    environment = {
#      user = var.username
#      host = element(
#        libvirt_domain.primary.*.network_interface.0.addresses.0,
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

