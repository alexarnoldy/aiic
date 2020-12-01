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
create_lb = false
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
secondarys = 2
secondary_memory = 1024
#secondary_memory = 16384
secondary_vcpu = 1
#secondary_vcpu = 12

# Number of tertiary nodes
tertiarys = 3
tertiary_memory = 1024
#tertiary_memory = 16384
tertiary_vcpu = 1
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
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGkun2+5NDxqfy995qWNW4dkKZ3GsSGM0S1VG7etZ7KMI8rEZWLjIgQ0BX9ayEAjiY5gUtoaG7P9YO/+O2T+ZOc+A2O4RiRreLNQ9FoLJF0ekfbK6heVLVF1d9z1AHhEulORK8T2Ggn4BIxTv+DDint6ebs+W1DyhCc4o5jCk3mZM19c3N/2yhgfHkDVgrDaxTmrTOAkiZGd26D06X8VteiH3ys/4VtP2j7ZFDJ3Jzz8ySDzRIkJ8OP1KJvHi6uz7aZLh2fLJQsoZttuCWMO7kZGd6OaQn0EJ5FSMAmP6C8b8afybdcMZZ1DaOnKn1Tk6vLeO7uV5squZn3r4t6yAb admin@infra2", "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6gNhnQe0q0wknKdl5/gQBKCcJKI38j/4A9nV349uDVkt6BZB2uFwd2IBvIp1JxYrUB4AoRNTrllMHX/v/D9Lg5hjcpv4Y9KBqrh3KGTfWNW3RDU3IILq+s2yFEe/M/0HPXew1uQsxc57k88Ix5B0wbZON6EzHeNhJuo/E0zezlVQ0qIHEnljXn5R5baZpek4QdJ+ywzw5OHiBuXvazKN8VDqMozjcxEhUoLhIqlPrmUmZ3nGQUDk8nKg2WDTpVMj8idJHSZ+gyHVwGF6aI9IcGOpIqTHJwomjfl6flxadEocTAFfETf+mRC2n/9sIxtKAI2Wi3Kr82loHrT7J8yMCIkfB/fsiSrhRA6UrxxVSzdCOZ9KybL3WxQh0544xmehyZzcAmiIFpAKJy9RV6mU29nH3cJcjteLqDwEiwoqpTvXq1fQRH7qhzPaNIKSAX6tOCy+xzqRVfm83uyJFd1jmGSI4tuWf/TNwI3uu6Mxa3dVW3akAK+/Jd/Uz3ZHgyaM= sles@aiic-admin"
]

# IMPORTANT: Replace these ntp servers with ones from your infrastructure
#ntp_servers = []
