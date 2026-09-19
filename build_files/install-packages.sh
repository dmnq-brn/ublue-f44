set -ouex pipefail

# All DNF-related operations should be done here whenever possible

# Base packages from repos - common to all versions
SHARED_PACKAGES=(
    # PackageKit-command-not-found
    # PackageKit-gtk3-module
    audit
    bootc
    # bpftool
    dnsmasq
    firewalld
    plymouth
    plymouth-system-theme
    polkit
    rsync
    realmd
    smartmontools
    usbguard
    vim-enhanced
)

GNOME_DESKTOP_PACKAGES=(
    # Gnome minimal desktop
    # ModemManager-glib required by gnome-control-center
    centos-backgrounds
    dconf
    fprintd-pam
    flatpak
    gdm
    glibc-all-langpacks
    gnome-control-center
    gnome-disk-utility
    gnome-initial-setup
    gnome-session-wayland-session
    gnome-settings-daemon
    gnome-shell
    # gnome-shell-extension-background-logo
    gnome-software
    # gvfs-fuse
    # gweather-locations
    # gweather-locations-common
    mesa-dri-drivers
    mesa-vulkan-drivers
    nautilus
    # orca
    ptyxis
    # required by Nautilus
    # totem-pl-parser
    tracker
    tracker-miners
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-user-dirs-gtk
    # yelp-tools
)

DEVELOPMENT_PACKAGES=(
    # toolbox
    distrobox
    git-core
    git-core-doc
)

QEMU_PACKAGES=(
    qemu-user-static
    qemu-user-static-aarch64
    qemu-user-static-alpha
    qemu-user-static-arm
    qemu-user-static-hexagon
    qemu-user-static-hppa
    qemu-user-static-loongarch64
    qemu-user-static-m68k
    qemu-user-static-microblaze
    qemu-user-static-mips
    qemu-user-static-or1k
    qemu-user-static-ppc
    qemu-user-static-riscv
    qemu-user-static-s390x
    qemu-user-static-sh4
    qemu-user-static-sparc
    qemu-user-static-x86
    qemu-user-static-xtensa
)

WIFI_PACKAGES=(
    NetworkManager-wifi
    iw
    iwlwifi-dvm-firmware
    iwlwifi-mvm-firmware
)

BLUETOOTH_PACKAGES=(
    NetworkManager-bluetooth
    bluez
)

GNOME_BLUETOOTH_PACKAGES=(
    gnome-bluetooth
    # gnome-bluetooth-libs
)

OPENSSH_SERVER_PACKAGES=(
    openssh-server
)

OPENSSH_CLIENT_PACKAGES=(
    openssh-server
)

UNVANTED_PACKAGES=(
    NetworkManager-adsl
    NetworkManager-cloud-setup
    NetworkManager-ovs
    NetworkManager-ppp
    NetworkManager-team
    NetworkManager-wwan
)

# Guest Desktop Agents
GUEST_AGENTS_PACKAGES=(
    hyperv-daemons
#    open-vm-tools-desktop
#    qemu-guest-agent
#    spice-vdagent
)

SERVER_PACKAGES=(
    "${SHARED_PACKAGES[@]}"
    "${GUEST_AGENTS_PACKAGES[@]}"
    "${OPENSSH_SERVER_PACKAGES[@]}"
)

DEVELOPMENT_SERVER_PACKAGES=(
    "${SERVER_PACKAGES[@]}"
    "${DEVELOPMENT_PACKAGES[@]}"
)

UNVANTED_DEVELOPMENT_SERVER_PACKAGES=(
    "${UNVANTED_PACKAGES[@]}"
    "${GNOME_DESKTOP_PACKAGES[@]}"
    "${BLUETOOTH_PACKAGES[@]}"
    "${GNOME_BLUETOOTH_PACKAGES[@]}"
    "${WIFI_PACKAGES[@]}"
    "${OPENSSH_CLIENT_PACKAGES[@]}"
    "${QEMU_PACKAGES[@]}"
)

UNVANTED_SERVER_PACKAGES=(
    "${UNVANTED_DEVELOPMENT_SERVER_PACKAGES[@]}"
    "${DEVELOPMENT_PACKAGES[@]}"
)

WORKSTATION_PACKAGES=(
    "${SHARED_PACKAGES[@]}"
    "${GNOME_DESKTOP_PACKAGES[@]}"
    "${GUEST_AGENTS_PACKAGES[@]}"
    "${OPENSSH_CLIENT_PACKAGES[@]}"
)

DEVELOPMENT_WORKSTATION_PACKAGES=(
    "${SHARED_PACKAGES[@]}"
    "${GNOME_DESKTOP_PACKAGES[@]}"
    *"${GUEST_AGENTS_PACKAGES[@]}"
    "${OPENSSH_CLIENT_PACKAGES[@]}"
    "${DEVELOPMENT_PACKAGES[@]}"
)

UNVANTED_DEVELOPMENT_WORKSTATION_PACKAGES=(
    "${UNVANTED_PACKAGES[@]}"
    "${BLUETOOTH_PACKAGES[@]}" 
    "${GNOME_BLUETOOTH_PACKAGES[@]}" 
    "${WIFI_PACKAGES[@]}" 
    "${OPENSSH_SERVER_PACKAGES[@]}" 
    "${QEMU_PACKAGES[@]}"
)

UNVANTED_WORKSTATION_PACKAGES=(
    "${UNVANTED_DEVELOPMENT_WORKSTATION_PACKAGES[@]}"
    "${DEVELOPMENT_PACKAGES[@]}"
)

# Install required packages
dnf -y --setopt=install_weak_deps=False install "${WORKSTATION_PACKAGES[@]}"

# remove unwanted packages
readarray -t INSTALLED < <(rpm -qa --queryformat='%{NAME}\n' "${UNVANTED_WORKSTATION_PACKAGES[@]}" 2>/dev/null || true)
if [[ "${#INSTALLED[@]}" -gt 0 ]]; then
    dnf -y remove "${INSTALLED[@]}"
else
    echo "No excluded packages found to remove."
fi

dnf -y upgrade
