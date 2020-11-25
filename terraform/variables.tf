
## Providing a libvirt_host_base hostname and a libvirt_host_number suffix allows deploying multiple clusters across multiple KVM hosts

variable "libvirt_hostname" {
  default     = "c3-b10.stable.suse.lab"
  description = "Hostname for KVM hosts on which to deploy a cluster"
}

variable "libvirt_user" {
  default     = "sles"
  description = "Name of the user in the libvirt group on the KVM host"
}

#variable "libvirt_host_base" {
#  default     = "infra"
#  description = "Base name for KVM hosts on which to deploy a cluster"
#}

#variable "libvirt_host_number" {
#  default     = "2"
#  description = "Suffix to identify the KVM host on which to deploy a cluster"
#}

#### Original connection method. Not used during initial testing
#variable "libvirt_uri" {
#  default     = "qemu:///system"
#  description = "URL of libvirt connection - default to localhost"
#}

#variable "libvirt_keyfile" {
#  default     = ""
#  description = "The private key file used for libvirt connection - default to none"
#}
####

variable "pool" {
  default     = "default"
  description = "Pool to be used to store all the volumes"
}

variable "image_uri" {
  default     = "images/vyos-router-template.qcow2"
  description = "URL of the image to use"
}

variable "company-project_name" {
  default     = "SUSE-aiic-test"
  description = "Format is company-project"
}

variable "authorized_keys" {
  type        = list(string)
  default     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLidPwttVNanTFpUL3JRshXhiieKdC6OAQl3MV8kXGPTvIq0psXDYrCUbUJbgzBFnFoij45NFSHsfz03weyPNp74zeh+SvLiQsJsizYkke6x7PiMxQGOndHytWd+Ri1m2j9X+YT7igNSTNVyoqte4nI87Kn87n4Bre0POnVySIvdSe61BhTQDsrJVyMN6qBlbBGPf/LBSXLkqFYLpjMlv56UGuxwW3Dum9vk9zYEslfl17PjgZ0UKMNNqKKSJssZ/AgJKhI0MlYQSg3e2HkKCRydNuraigUshtnKgRVkXFwv3tITyIPyo9kuKtDWwV6wnbG/gOpLrQsrlT31qo5snR sles@hol1289-base"]
  description = "SSH keys to inject into all the nodes"
}

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

#variable "inside_network" {
#  type        = string
#  default     = "241"
#  description = "Private client network"
#}

variable "inside_bridge" {
  type        = string
  default     = "br241"
  description = "Private client network"
}

variable "network_name" {
  default     = ""
  description = "The virtual network name to use. If provided just use the given one (not managed by terraform), otherwise terraform creates a new virtual network resource"
}


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

