# URL of the libvirt server
# EXAMPLE:
# libvirt_uri = "qemu:///system"
libvirt_uri = ""


# Way of connecting to different KVM servers
# host_base is the hostname until a final number designator
#
#
#variable "libvirt_host_base" {
#variable "libvirt_host_number" {

# Path of the key file used to connect to the libvirt server
# Note this value will be appended to the libvirt_uri as a 'keyfile' query: <libvirt_uri>?keyfile=<libvirt_keyfile>
# EXAMPLE:
# libvirt_keyfile = "~/.ssh/custom_id"
libvirt_keyfile = ""

# URL of the image to use
# EXAMPLE:
# image_uri = "http://download.suse.com/..."
#image_uri = ""

# Identifier to make all your resources unique and avoid clashes with other users of this terraform project
#stack_name = ""


# CaaS Platform registration code ONLY when registering with SCC
#caasp_registry_code = ""

# RMT server to register against when NOT registering with SCC. Don't include http(s)://
#rmt_server_name = ""

# DNS domain of the cluster. This will also be used as the name of the CaaS Platform cluster for automated deployment
#dns_domain = ""

# CIDR of the network
#network_cidr = ""







# Set create_lb to false when deploying on a single KVM host, and true when deploying across multiple KVM hosts (when that feature is available)
# Note that the jumphost node will eventually be configured to provide a single load balancer instance
# Enable creation of LB node
#create_lb = false
#lbs = 0
#lb_memory = 4096
#lb_vcpu = 1

# Set jumphosts to 1 to deploy an jumphost node (required for automated deployment). 0 for no jumphost node
jumphosts = 1
#jumphost_memory = 4096
jumphost_memory = 2048
#jumphost_vcpu = 2
# Jumphost node provides NFS peristent storage in and automated deployment. Adjust jumphost_disk_size if more storage is needed
#jumphost_disk_size = 25769803776
jumphost_disk_size = 59055800320

# Number of primary nodes
primarys = 1
primary_memory = 1024
primary_vcpu = 1

# Number of secondary nodes
secondarys = 0
secondary_memory = 1024
#secondary_memory = 16384
secondary_vcpu = 2
#secondary_vcpu = 12

# Number of tertiary nodes
tertiarys = 0
tertiary_memory = 1024
#tertiary_memory = 16384
tertiary_vcpu = 4
#tertiary_vcpu = 12

# Username for the cluster nodes
# EXAMPLE:
#username = "sles"

# Password for the cluster nodes
# EXAMPLE:
#password = "linux"

# define the repositories to use
# EXAMPLE:
# repositories = {
#   repository1 = "http://example.my.repo.com/repository1/"
#   repository2 = "http://example.my.repo.com/repository2/"
# }
repositories = {}

# define the repositories to use for the loadbalancer node
# EXAMPLE:
# repositories = {
#   repository1 = "http://example.my.repo.com/repository3/"
#   repository2 = "http://example.my.repo.com/repository4/"
# }
lb_repositories = {}

# Minimum required packages. Do not remove them.
# Feel free to add more packages
#packages = [
#  "nfs-client",
#  "kernel-default",
#  "-kernel-default-base"
#]

# SSH keys to be injected into the cluster nodes. If deploying an jumphost node, should include the key from that node.
# EXAMPLE:
# authorized_keys = [
#  "ssh-rsa <key1-content>",
#  "ssh-rsa <key2-content>"
# ]
authorized_keys = [
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6RX3hB2ZmiteyeUwhQBHGBH9uAI1zPNT8ktGVx6XijbWHa2CMukCvtF1Z27tcabqDZmAwSnm8zsYxLOw01e2gnpoRCd/XDjs+jKiTK2+JCrhYeUdkcIdYsurQ/km7H4lIzDNoH8fVS+/Q1yKYT/Y2bQmKKSIb40JDDLFNJl0Wkek0n6NXbGILM6aCUI6GwwRCeqpfNAhFR9bJKCA8fT89kiB3n2bjcbWvCbvVJXZUzsq6D+d3UIAh43ZV6OTAF04vE3C//pj8HsBnjQgBKql05lL+6fl5nAKK0aEc/VHEZ/gz2y5dxj69yfe84Xd7oOWYbJTDFxVlvNWyZ10IZR0v4RkQmjBYFRwQmWn9fDQ76KFoW2xYe+sYaY7RfUfp+TEfz0+yIdSzqe0685oNoTBfWA0/cpdAjPo1LXoBrLJkKO5Hu+seQkMa+/m7H3BPuXqHhZu815ubMyvC42H9MiBEs5UFjjOZZUsv6OoV40GeTY1Wse1112Aj+uOSILMvULk= sles@c3-b10.stable.suse.lab", "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+FToq+7JLjKg/GIW0xPFu/htRu0uoTrdnocJwFBdti+OqgD750aqOi+DNBdz3vVbv7taoPvQA47vAAej/uVzJmf+clkU/A4SpxH2G7/tcRIFxC2kQoVQhimIUaEJ+f7wcXl0jGCeiWB/wHoN52itocElsWFBF6giGehwxWpy7OmHuKa2aLv6TNMhjFmN932vur3rG5JATivVPx7sPv/8uJrB4L+/VqB2YbAb2w0m5DJPXSlhTPJGQRxHKBZw1a1MEje20Tqh5r0BhQcH4pPci6XAVwN9PfotLMuRtWJ/nA6GZ8uMiETqSFDDEltBJwDOH+AmYeUJbKJ9mjhARoTQiR1/XXGJZIqzj4b1bTbVtQeRsj7VwTG1u90/BPZCOmjI3L86MPHNy5YPBWPwrdQM2Mhzm+/vdDdms45ooGFlP96Y5yBVKHiAd0Fc1bC1vjw+Qe3IKUwKkgfdf6CJODZLZ0LZtB4Rzch65iqpjY9PBchJ9Fy7pGZtoRHHIWgCFDac= sles@aiic-admin"
]

# IMPORTANT: Replace these ntp servers with ones from your infrastructure
#ntp_servers = []
