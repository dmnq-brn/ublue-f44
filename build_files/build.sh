#!/bin/bash

set -euxo pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install required OS packages
/ctx/install-packages.sh

# Disable all repos (should already be disabled by helpers, but ensure)
#for repo in /etc/yum.repos.d/*.repo; do
#    if [[ -f "$repo" ]]; then
#        sed -i 's@enabled=1@enabled=0@g' "$repo"
#    fi
#done

# Setup Systemd
## Remove systemd unwanted services
### fedora flatpak remote repository
systemctl disable flatpak-add-fedora-repos.service
rm /usr/lib/systemd/system/flatpak-add-fedora-repos.service

### rpm-ostree
systemctl disable rpm-ostree-countme.service
rm /usr/lib/systemd/system/rpm-ostree-countme.service
systemctl disable rpm-ostree-countme.timer
rm /usr/lib/systemd/system/rpm-ostree-countme.timer

## Enable systemd required services
### flatpak preinstall
systemctl enable flatpak-preinstall.service

# Remove gnome-initial-setup default configuration
rm /usr/share/dconf/profile/gnome-initial-setup
rm /usr/share/gnome-initial-setup/initial-setup-dconf-defaults
rm /usr/share/gnome-initial-setup/vendor.conf
