
## Providing a libvirt_host_base hostname and a libvirt_host_number suffix allows deploying multiple clusters across multiple KVM hosts

variable "libvirt_hostname" {
  default     = "infra2.caaspv4.com"
  description = "Hostname for KVM hosts on which to deploy a cluster"
}

variable "libvirt_user" {
  default     = "admin"
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
  default     = "images/SLES15-SP1-JeOS.x86_64-15.1-OpenStack-Cloud-QU2.qcow2"
  description = "URL of the image to use"
}

variable "repositories" {
  type        = map(string)
  default     = {}
  description = "Urls of the repositories to mount via cloud-init"
}

#variable "stack_name" {
#  default     = "caasp"
#  description = "Identifier to make all your resources unique and avoid clashes with other users of this terraform project"
#}

variable "company-project_name" {
  default     = "SUSE-aiic-test"
  description = "Format is company-project"
}

variable "authorized_keys" {
  type        = list(string)
  default     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGkun2+5NDxqfy995qWNW4dkKZ3GsSGM0S1VG7etZ7KMI8rEZWLjIgQ0BX9ayEAjiY5gUtoaG7P9YO/+O2T+ZOc+A2O4RiRreLNQ9FoLJF0ekfbK6heVLVF1d9z1AHhEulORK8T2Ggn4BIxTv+DDint6ebs+W1DyhCc4o5jCk3mZM19c3N/2yhgfHkDVgrDaxTmrTOAkiZGd26D06X8VteiH3ys/4VtP2j7ZFDJ3Jzz8ySDzRIkJ8OP1KJvHi6uz7aZLh2fLJQsoZttuCWMO7kZGd6OaQn0EJ5FSMAmP6C8b8afybdcMZZ1DaOnKn1Tk6vLeO7uV5squZn3r4t6yAb admin@infra2", "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUrbRE8QBHSHvty8Y4g/iFveUlIHTK4590NYN4txCBsup7xEednzcGISCfbI2LcvwGRtmeDnhJ3CyA4j2A83neWNKotD7SoYtYQzLP9RmDGfRL1+lLHebAOvTt4JxG1xL8ay5QdsXRMvmvBcLZtZVfICT776R98XUbN2OX3LDCYusg7TwleR1TBDAASzpEoy1bFxrO7Eu6x9fBhELjYigZAs/NMkNr/BTrbByxy8JwxyTWrY6aHbrAulVWUDnBQum07QF3UDqWlgAfeUMNDUf6HevGPmWWD+CVu0T6o7QUjP8h+bFmIT7SpoAekziPsfMF2xPh/PUqzR00g8g6Aoi7 sles@caasp-admin"]
  description = "SSH keys to inject into all the nodes"
}

variable "ntp_servers" {
  type        = list(string)
  default     = ["0.novell.pool.ntp.org", "1.novell.pool.ntp.org", "2.novell.pool.ntp.org", "3.novell.pool.ntp.org"]
  description = "List of NTP servers to configure"
}

variable "packages" {
  type = list(string)

  default = [
    "nfs-client",
    "kernel-default",
    "-kernel-default-base"
  ]

  description = "List of packages to install on all nodes"
}

variable "jumphost_only_packages" {
  type = list(string)

  default = [
    "kernel-default",
    "-kernel-default-base",
    "nfs-kernel-server", 
    "netcat-openbsd",
    "nmap",
    "ipcalc",
    "w3m"
  ]

  description = "List of packages to install on the jumphost node"
}

#variable "jumphost_only_patterns" {
#  type = list(string)
#
#  default = [
#    "SUSE-CaaSP-Management"
#  ]
#
#  description = "List of patterns to install on the jumphost node"
#}

variable "username" {
  default     = "sles"
  description = "Username for the cluster nodes"
}

variable "password" {
  default     = "linux"
  description = "Password for the cluster nodes"
}

variable "caasp_registry_code" {
  default     = ""
  description = "SUSE CaaSP Product Registration Code"
}

variable "ha_registry_code" {
  default     = ""
  description = "SUSE Linux Enterprise High Availability Extension Registration Code"
}

variable "rmt_server_name" {
  default     = "rmt.hol1289.local"
  description = "SUSE Repository Mirroring Server Name. Don't include http(s)://"
}

variable "dns_domain" {
  type        = string
  default     = "caasp.local"
  description = "Name of DNS Domain. This will also be used as the name of the CaaS Platform cluster for automatic deployment"
}

variable "network_cidr" {
  type        = string
  default     = "10.110.0.0/22"
  description = "Network used by the cluster"
}

variable "network_mode" {
  type        = string
#  default     = "nat"
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
#  description = "Number of load-balancer nodes. Note that the jumphost node will eventually be configured to provide a single load balancer instance"
#}

variable "create_lb" {
  type        = bool
  default     = true
  description = "Create load balancer node exposing primary nodes"
}

variable "lb_memory" {
  default     = 4096
  description = "Amount of RAM for a load balancer node"
}

variable "lb_vcpu" {
  default     = 1
  description = "Amount of virtual CPUs for a load balancer node"
}

variable "lb_disk_size" {
  default     = "25769803776"
  description = "Disk size (in bytes)"
}

variable "lb_repositories" {
  type = map(string)

  default = {
    sle_server_pool    = "http://download.suse.de/ibs/SUSE/Products/SLE-Product-SLES/15-SP1/x86_64/product/"
    basesystem_pool    = "http://download.suse.de/ibs/SUSE/Products/SLE-Module-Basesystem/15-SP1/x86_64/product/"
    ha_pool            = "http://download.suse.de/ibs/SUSE/Products/SLE-Product-HA/15-SP1/x86_64/product/"
    ha_updates         = "http://download.suse.de/ibs/SUSE/Updates/SLE-Product-HA/15-SP1/x86_64/update/"
    sle_server_updates = "http://download.suse.de/ibs/SUSE/Updates/SLE-Product-SLES/15-SP1/x86_64/update/"
    basesystem_updates = "http://download.suse.de/ibs/SUSE/Updates/SLE-Module-Basesystem/15-SP1/x86_64/update/"
  }
}

variable "jumphosts" {
  default     = 1
  description = "1 for fully automated deployment. 0 for no jumphost node to be deployed with the cluster"
}

variable "jumphost_memory" {
  default     = 4096
  description = "The amount of RAM for the jumphost"
}

variable "jumphost_vcpu" {
  default     = 2
  description = "The amount of virtual CPUs for the jumphost"
}

variable "jumphost_disk_size" {
  default     = "25769803776"
  description = "Disk size (in bytes)"
}

variable "primarys" {
  default     = 0
  description = "Number of primary nodes"
}

variable "primary_memory" {
  default     = 4096
  description = "Amount of RAM for a primary"
}

variable "primary_vcpu" {
  default     = 2
  description = "Amount of virtual CPUs for a primary"
}

variable "primary_disk_size" {
  default     = "25769803776"
  description = "Disk size (in bytes)"
}

variable "secondarys" {
  default     = 0
  description = "Number of secondary nodes"
}

variable "secondary_memory" {
  default     = 4096
  description = "Amount of RAM for a secondary"
}

variable "secondary_vcpu" {
  default     = 2
  description = "Amount of virtual CPUs for a secondary"
}

variable "secondary_disk_size" {
  default     = "25769803776"
  description = "Disk size (in bytes)"
}
variable "tertiarys" {
  default     = 0
  description = "Number of tertiary nodes"
}

variable "tertiary_memory" {
  default     = 4096
  description = "Amount of RAM for a tertiary"
}

variable "tertiary_vcpu" {
  default     = 2
  description = "Amount of virtual CPUs for a tertiary"
}

variable "tertiary_disk_size" {
  default     = "25769803776"
  description = "Disk size (in bytes)"
}
