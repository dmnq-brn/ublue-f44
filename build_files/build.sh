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

### remove fedora flatpak remote
#flatpak remote-delete fedora
#flatpak remote-delete fedora-testing
systemctl disable flatpak-add-fedora-repos.service
rm /usr/lib/systemd/system/flatpak-add-fedora-repos.service

### add flathub repository
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

### install flatpack app

#flatpak install flathub org.mozilla.firefox
#flatpak install flathub net.nokyan.Resources
flatpak install -y --system flathub com.mattjakeman.ExtensionManager

#### Example for enabling a System Unit File

systemctl enable podman.socket

systemctl set-default graphical.target
