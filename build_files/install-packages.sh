set -ouex pipefail

# All DNF-related operations should be done here whenever possible

# Base packages from repos - common to all versions
SHARED_PACKAGES=(
    # Gnome minimal desktop
    # PackageKit-command-not-found
    # PackageKit-gtk3-module
    audit
    bootc
    # bpftool
    dconf
    dnsmasq
    firewalld
    fprintd-pam
    gdm
    glibc-all-langpacks
    gnome-control-center
    gnome-disk-utility
#    gnome-initial-setup
    gnome-session-wayland-session
    gnome-settings-daemon
    gnome-shell
    # gnome-shell-extension-background-logo
    gnome-software
    # gvfs-fuse
    mesa-dri-drivers
    mesa-vulkan-drivers
    nautilus
    # orca
    plymouth
    plymouth-system-theme
    polkit
    ptyxis
    rsync
    realmd
    smartmontools
    tracker
    tracker-miners
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-user-dirs-gtk
    # yelp-tools
    vim-enhanced
)

DEVELOPMENT_PACKAGES=(
    toolbox
    distrobox
    git-core
    git-core-doc
)

WIFI_PACKAGES=(
    iw
    iwlwifi-dvm-firmware
    iwlwifi-mvm-firmware
    NetworkManager-wifi
)

BLUETOOTH_PACKAGES=(
    bluez
    gnome-bluetooth
)

# centos specific packages
CENTOS_PACKAGES=(
    centos-backgrounds
)

FEDORA_PACKAGES=(

)

FONTS_PACKAGES=(
    default-fonts-cjk-mono
    default-fonts-cjk-sans
    default-fonts-cjk-serif
    default-fonts-core-emoji
    default-fonts-core-math 
    default-fonts-core-mono
    default-fonts-core-sans
    default-fonts-core-serif
    default-fonts-other-mono
    default-fonts-other-sans
    default-fonts-other-serif
    dejavu-sans-fonts
    dejavu-sans-mono-fonts
    dejavu-serif-fonts
    google-carlito-fonts
    google-crosextra-caladea-fonts
    google-droid-sans-fonts
    google-droid-sans-mono-fonts
    google-droid-serif-fonts
    google-noto-emoji-fonts
    google-noto-fonts-all
    google-noto-sans-cjk-fonts
    google-roboto-slab-fonts pt-sans-fonts
    redhat-display-vf-fonts
    redhat-mono-vf-fonts
    redhat-text-vf-fonts    
)

# Guest Desktop Agents
GUEST_DESKTOP_AGENTS=(
    hyperv-daemons
#    open-vm-tools-desktop
#    qemu-guest-agent
#    spice-vdagent
)

# Install required packages
dnf -y --setopt=install_weak_deps=False install "${SHARED_PACKAGES[@]}" "${GUEST_DESKTOP_AGENTS[@]}"

# remove unwanted packages
readarray -t INSTALLED < <(rpm -qa --queryformat='%{NAME}\n' "${BLUETOOTH_PACKAGES[@]}" "${WIFI_PACKAGES[@]}" "${DEVELOPMENT_PACKAGES[@]}" 2>/dev/null || true)
if [[ "${#INSTALLED[@]}" -gt 0 ]]; then
    dnf -y remove "${INSTALLED[@]}"
else
    echo "No excluded packages found to remove."
fi

dnf -y upgrade
