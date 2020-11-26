#cloud-config

# set locale
locale: en_US.UTF-8

# set timezone
timezone: Etc/UTC

# set root password
chpasswd:
  list: |
    root:linux
    ${username}:${password}
  expire: False

ssh_authorized_keys:
${authorized_keys}

ntp:
  enabled: true
  ntp_client: chrony
  config:
    confpath: /etc/chrony.conf
  servers:
${ntp_servers}

# need to disable gpg checks because the cloud image has an untrusted repo
zypper:
  repos:
${repositories}
  config:
    gpgcheck: "off"
    solver.onlyRequires: "true"
    download.use_deltarpm: "true"

# need to remove the standard docker packages that are pre-installed on the
# cloud image because they conflict with the kubic- ones that are pulled by
# the kubernetes packages
# WARNING!!! Do not use cloud-init packages module when SUSE CaaSP Registraion
# Code is provided. In this case repositories will be added in runcmd module 
# with SUSEConnect command after packages module is ran
#packages:

bootcmd:
  - ip link set dev eth0 mtu 1400
  # Hostnames from DHCP - otherwise localhost will be used
  - /usr/bin/sed -ie "s#DHCLIENT_SET_HOSTNAME=\"no\"#DHCLIENT_SET_HOSTNAME=\"yes\"#" /etc/sysconfig/network/dhcp
  - netconfig update -f

runcmd:
${register_scc}
${register_rmt}
${commands}



final_message: "The system is finally up, after $UPTIME seconds"

write_files:
  - path: /home/sles/.ssh/id_rsa
    content: H4sICOf6vl8AA2lkX3JzYQDLK83J0U3MS9Ety89M4QIAt900BQ4AAAA=
    encoding: gz+b64
    permissions: "0600"
  - path: /home/sles/.ssh/id_rsa.pub
    content: H4sICOf6vl8AA2lkX3JzYS5wdWIAyyvNydFNzEvRLcvPTOECALfdNAUOAAAA
    encoding: gz+b64
    permissions: "0600"
  - path: /tmp/deploy_caasp.sh
    content: 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
    encoding: gz+b64
    permissions: "0755"
  - path: /root/recover_deployment.sh
    content: H4sICGIsgl4AA3JlY292ZXJfZGVwbG95bWVudC5zaAAdjjEOwyAQBHtesRFFKkKfF6T2ByIMZ4GEOcQdivx722lHI83Yh19L82uQbKzFMhuCYDArygbNhFh5JpRWFBJH6SpITNKeiu2ikhF5DIpaDxMz/xrcAqkk7yk0BD7zTv4GRmZiuA/c/Au4q/C6d5+oVz6+MQTpr2vlBBtSVPuXAAAA
    encoding: gz+b64
    permissions: "0755"
  - path: /home/sles/.bashrc
    content: H4sICGIsgl4AAy5iYXNocmMAdc4xDsMgDIXhPaew2DlCDuNiJ0JxANWmVaQevnQhQUrn/3uWlQ18hlecUCIqbGua3VYfHExgbTFlYv2RdyR2XdGoiIvkY+dkN7aMtmS6Q/hfgfco4hPurAVD++cDwqoO+nwc97O4nAFLkQP80iNdIrGw8aVq0NlpywhBqho/QQ2tqpu+dF8aTjQBAAA=
    encoding: gz+b64
    permissions: "0644"
  - path: /tmp/k8s-test.sh
    content: H4sICKMBz14AA2s4cy10ZXN0LnNoAKWUTWvbQBCG7/oVU+UWIsshUIpIAiG0pYc0pgnuofQw3h1Z2+yHurtyYuiP76wkO7GTtIWCDd6Z2Xee+VgfvCkXypYLDE2WHRzALYUIsSEInRAUQt3pI8AuOoNRCaidTz+cBVcDwiXiDcw0xmQHobsQySeZT5YPkgJE1lN2ybGSaux0hBCdxyVxNIaQZRMoG2eoDJpCOUkcXgwkjQrAnwa9FE6ShOh6sptB4DLdn8CF/MFZAQNYIo7K7roFiajhHlWEomCyM+GsVIn6DFeoNC40sScqQ66LZyfTaWC6Vru1IRvL0AXiG4WtQ/8VWrG5aL1bqcAiXGFGonGQz8mreg2oNViXqkVP4AnlusrhHMpo2vLuXZjEh7jFWlIcgwsH90oSnO9FDtr5K/YxZ5Irwpr7bQCt3GkKtE6OLJ213P3qudhTnD68uPg/oB0AHpunpUrbwHNLfCpsFuAvMEG8yrGNw7bVayhqKOD0FA7fX384zO6UlRXMyIeU1sa5051JOMpk2Kp5cjhbweo4MxRRYsQqA7BoqOq3tGhXIgstiWTGfvmv0pzSsYAvPNWvXkW6toLY4im4zovBnY4/O9YYT7BZ8gqOP6psAHyZfvDtAY61OPkqKrs2qLyqERVv5Ug6hKFu2dbTKNOTPLEIZwymFN9yfnbU5kf5ydvpNP/ee1d9565cZzf1FGDSaYaxqaA0/EZ6Cg4cy32CNhgHjR2inSvtS3PaNE+kw+fdwez18MXHnWa03n/Y3Kpy27N/2uTYYITZ/DLtbF83r7Cy/V9PEkqKf9hheiDeYKbbJGWgQQZ+wdJTu23EM4l+FnA83WpJ0hQpJXwc+75vJR6blP0Gu3kvhM4FAAA=
    encoding: gz+b64
    permissions: "0755"
