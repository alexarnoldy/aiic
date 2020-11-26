#!/bin/bash
## Run as root if the cloud init scripts doesn't finish correctly
chown -R sles:users /home/sles
sudo -H -u sles bash /tmp/deploy_caasp.sh
