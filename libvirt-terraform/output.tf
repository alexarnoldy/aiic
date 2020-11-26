output "ip_load_balancer" {
  value = var.create_lb ? zipmap(libvirt_domain.lb.*.network_interface.0.hostname, libvirt_domain.lb.*.network_interface.0.addresses.0) : {}
}

output "ip_jumphost" {
  value = zipmap(
    libvirt_domain.jumphost.*.network_interface.0.hostname,
    libvirt_domain.jumphost.*.network_interface.0.addresses.0,
  )
}

output "ip_primaries" {
  value = zipmap(
    libvirt_domain.primary.*.network_interface.0.hostname,
    libvirt_domain.primary.*.network_interface.0.addresses.0,
  )
}

output "ip_secondaries" {
  value = zipmap(
    libvirt_domain.secondary.*.network_interface.0.hostname,
    libvirt_domain.secondary.*.network_interface.0.addresses.0,
  )
}
output "ip_tertiaries" {
  value = zipmap(
    libvirt_domain.tertiary.*.network_interface.0.hostname,
    libvirt_domain.tertiary.*.network_interface.0.addresses.0,
  )
}
