
## Providing a libvirt_host_base hostname and a libvirt_host_number suffix allows deploying multiple clusters across multiple KVM hosts

variable "libvirt_hostname" {
#  default     = "infra2.suse.hpc.local"
  default     = "c3-b10.stable.suse.lab"
  description = "Hostname for KVM hosts on which to deploy a cluster"
}

variable "libvirt_user" {
#  default     = "admin"
  default     = "sles"
  description = "Name of the user in the libvirt group on the KVM host"
}

variable "libvirt_host_base" {
  default     = "infra"
  description = "Base name for KVM hosts on which to deploy a cluster"
}

variable "libvirt_host_number" {
  default     = "2"
  description = "Suffix to identify the KVM host on which to deploy a cluster"
}

#### Original connection method. Not used during initial testing
variable "libvirt_uri" {
  default     = "qemu:///system"
  description = "URL of libvirt connection - default to localhost"
}

variable "libvirt_keyfile" {
  default     = ""
  description = "The private key file used for libvirt connection - default to none"
}
####

variable "pool" {
  default     = "default"
  description = "Pool to be used to store all the volumes"
}

variable "image_uri" {
  default     = "images/vyos-router-template.qcow2"
  description = "URL of the image to use"
}

#variable "repositories" {
#  type        = map(string)
#  default     = {}
#  description = "Urls of the repositories to mount via cloud-init"
#}

variable "stack_name" {
  default     = "test-router"
  description = "Identifier to make all your resources unique and avoid clashes with other users of this terraform project"
}

variable "authorized_keys" {
  type        = list(string)
  default     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLidPwttVNanTFpUL3JRshXhiieKdC6OAQl3MV8kXGPTvIq0psXDYrCUbUJbgzBFnFoij45NFSHsfz03weyPNp74zeh+SvLiQsJsizYkke6x7PiMxQGOndHytWd+Ri1m2j9X+YT7igNSTNVyoqte4nI87Kn87n4Bre0POnVySIvdSe61BhTQDsrJVyMN6qBlbBGPf/LBSXLkqFYLpjMlv56UGuxwW3Dum9vk9zYEslfl17PjgZ0UKMNNqKKSJssZ/AgJKhI0MlYQSg3e2HkKCRydNuraigUshtnKgRVkXFwv3tITyIPyo9kuKtDWwV6wnbG/gOpLrQsrlT31qo5snR sles@hol1289-base"]
  description = "SSH keys to inject into all the nodes"
}
#
#variable "ntp_servers" {
#  type        = list(string)
#  default     = ["0.novell.pool.ntp.org", "1.novell.pool.ntp.org", "2.novell.pool.ntp.org", "3.novell.pool.ntp.org"]
#  description = "List of NTP servers to configure"
#}
#
#variable "packages" {
#  type = list(string)
#
#  default = [
#    "nfs-client",
#    "kernel-default",
#    "-kernel-default-base"
#  ]
#
#  description = "List of packages to install on all nodes"
#}
#
#variable "admin_only_packages" {
#  type = list(string)
#
#  default = [
#    "kernel-default",
#    "-kernel-default-base",
#    "nfs-kernel-server", 
#    "netcat-openbsd",
#    "nmap",
#    "ipcalc",
#    "w3m"
#  ]
#
#  description = "List of packages to install on the admin node"
#}
#
#variable "admin_only_patterns" {
#  type = list(string)
#
#  default = [
#    "SUSE-CaaSP-Management"
#  ]
#
#  description = "List of patterns to install on the admin node"
#}

#variable "username" {
#  default     = "sles"
#  description = "Username for the cluster nodes"
#}
#
#variable "password" {
#  default     = "linux"
#  description = "Password for the cluster nodes"
#}
#
#variable "caasp_registry_code" {
#  default     = ""
#  description = "SUSE CaaSP Product Registration Code"
#}
#
#variable "ha_registry_code" {
#  default     = ""
#  description = "SUSE Linux Enterprise High Availability Extension Registration Code"
#}
#
#variable "rmt_server_name" {
#  default     = "rmt.hol1289.local"
#  description = "SUSE Repository Mirroring Server Name. Don't include http(s)://"
#}
#
#variable "dns_domain" {
#  type        = string
#  default     = "caasp.local"
#  description = "Name of DNS Domain. This will also be used as the name of the CaaS Platform cluster for automatic deployment"
#}
#
#variable "network_cidr" {
#  type        = string
#  default     = "10.110.0.0/22"
#  description = "Network used by the cluster"
#}

variable "network_mode" {
  type        = string
  default     = "bridge"
  description = "Network mode used by the cluster"
}

variable "outside_bridge" {
  type        = string
  default     = "br240"
  description = "Lab LAN network"
}

variable "inside_bridge" {
  type        = string
  default     = "br241"
  description = "Private client network"
}

variable "network_name" {
  default     = ""
  description = "The virtual network name to use. If provided just use the given one (not managed by terraform), otherwise terraform creates a new virtual network resource"
}

#variable "lbs" {
#  default     = 0
#  description = "Number of load-balancer nodes. Note that the admin node will eventually be configured to provide a single load balancer instance"
#}

#variable "create_lb" {
#  type        = bool
#  default     = true
#  description = "Create load balancer node exposing master nodes"
#}
#
#variable "lb_memory" {
#  default     = 4096
#  description = "Amount of RAM for a load balancer node"
#}
#
#variable "lb_vcpu" {
#  default     = 1
#  description = "Amount of virtual CPUs for a load balancer node"
#}
#
#variable "lb_disk_size" {
#  default     = "25769803776"
#  description = "Disk size (in bytes)"
#}
#
#variable "lb_repositories" {
#  type = map(string)
#
#  default = {
#    sle_server_pool    = "http://download.suse.de/ibs/SUSE/Products/SLE-Product-SLES/15-SP1/x86_64/product/"
#    basesystem_pool    = "http://download.suse.de/ibs/SUSE/Products/SLE-Module-Basesystem/15-SP1/x86_64/product/"
#    ha_pool            = "http://download.suse.de/ibs/SUSE/Products/SLE-Product-HA/15-SP1/x86_64/product/"
#    ha_updates         = "http://download.suse.de/ibs/SUSE/Updates/SLE-Product-HA/15-SP1/x86_64/update/"
#    sle_server_updates = "http://download.suse.de/ibs/SUSE/Updates/SLE-Product-SLES/15-SP1/x86_64/update/"
#    basesystem_updates = "http://download.suse.de/ibs/SUSE/Updates/SLE-Module-Basesystem/15-SP1/x86_64/update/"
#  }
#}

variable "routers" {
  default     = 1
  description = "1 for fully automated deployment. 0 for no admin node to be deployed with the cluster"
}

variable "router_memory" {
  default     = 2048
  description = "The amount of RAM for the router"
}

variable "router_vcpu" {
  default     = 2
  description = "The amount of virtual CPUs for the router"
}

variable "router_disk_size" {
  default     = "2147483648"
  description = "Disk size (in bytes)"
}

#variable "masters" {
#  default     = 1
#  description = "Number of master nodes"
#}
#
#variable "master_memory" {
#  default     = 4096
#  description = "Amount of RAM for a master"
#}
#
#variable "master_vcpu" {
#  default     = 2
#  description = "Amount of virtual CPUs for a master"
#}
#
#variable "master_disk_size" {
#  default     = "25769803776"
#  description = "Disk size (in bytes)"
#}
#
#variable "workers" {
#  default     = 2
#  description = "Number of worker nodes"
#}
#
#variable "worker_memory" {
#  default     = 4096
#  description = "Amount of RAM for a worker"
#}
#
#variable "worker_vcpu" {
#  default     = 2
#  description = "Amount of virtual CPUs for a worker"
#}
#
#variable "worker_disk_size" {
#  default     = "25769803776"
#  description = "Disk size (in bytes)"
#}
