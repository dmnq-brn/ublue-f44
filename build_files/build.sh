#!/bin/bash

set -euxo pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install required OS packages
/ctx/install-packages.sh

### Remove unwanted OS package 
# /ctx/remove-packages.sh

### remove dnf repository
# rm /etc/yum.repos.d/*.repo
### remove gnome-initial-setup defaults configuration
rm /usr/share/dconf/gnome-initial-setup
rm /usr/share/gnome-initial-setup/initial-setup-dconf-defaults
rm /usr/share/gnome-initial-setup/vendor.conf

### remove fedora flatpak remote repository
#flatpak remote-delete fedora
#flatpak remote-delete fedora-testing
systemctl disable flatpak-add-fedora-repos.service
rm /usr/lib/systemd/system/flatpak-add-fedora-repos.service

### add flathub flatpak remote repository
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

### install flatpack app
flatpak install -y --noninteractive --system flathub com.mattjakeman.ExtensionManager
flatpak install -y --noninteractive --system flathub page.tesk.Refine
flatpak install -y --noninteractive --system flathub net.nokyan.Resources
# flatpak install -y --noninteractive --system flathub com.google.Chrome

