#!/bin/bash

set -euxo pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install required packages
/ctx/install-packages.sh

### remove 
# /ctx/remove-packages.sh

#### Example for enabling a System Unit File

systemctl enable podman.socket

systemctl set-default graphical.target
