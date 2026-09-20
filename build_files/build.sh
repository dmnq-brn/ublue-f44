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

### Setup Systemd

### remove systemd unwanted services
## fedora flatpak remote repository
systemctl disable flatpak-add-fedora-repos.service
rm /usr/lib/systemd/system/flatpak-add-fedora-repos.service

## rpm-ostree
systemctl disable rpm-ostree-countme.service
rm /usr/lib/systemd/system/rpm-ostree-countme.service
systemctl disable rpm-ostree-countme.timer
rm /usr/lib/systemd/system/rpm-ostree-countme.timer

### remove gnome-initial-setup defaults configuration
rm /usr/share/dconf/profile/gnome-initial-setup
rm /usr/share/gnome-initial-setup/initial-setup-dconf-defaults
rm /usr/share/gnome-initial-setup/vendor.conf

### add flathub flatpak remote repository
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

### install flatpack app
flatpak install -y --noninteractive --system flathub com.mattjakeman.ExtensionManager
flatpak install -y --noninteractive --system flathub page.tesk.Refine
flatpak install -y --noninteractive --system flathub net.nokyan.Resources
# flatpak install -y --noninteractive --system flathub com.google.Chrome

