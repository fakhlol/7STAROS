#!/bin/bash
# 7STAROS GNOME Setup Script for Cubic
# Copy-paste SEMUA baris ini di terminal Cubic chroot

echo "=== 7STAROS GNOME Edition Setup ==="

# Update system
apt update
apt upgrade -y

# Install GNOME minimal (NO BLOAT)
apt install -y --no-install-recommends \
    ubuntu-desktop-minimal \
    gnome-shell \
    gnome-terminal \
    nautilus \
    gnome-control-center \
    gnome-tweaks \
    gdm3 \
    gnome-software \
    firefox-esr \
    network-manager-gnome \
    pulseaudio \
    pavucontrol

# Install essential developer tools
apt install -y \
    nano vim \
    curl wget git \
    htop neofetch \
    python3 python3-pip \
    nodejs npm \
    build-essential \
    docker.io docker-compose \
    gparted \
    openssh-server

# Remove SNAP completely
systemctl stop snapd 2>/dev/null || true
apt remove -y --purge snapd gnome-software-plugin-snap
rm -rf ~/snap /snap /var/snap /var/lib/snapd

# Remove unnecessary GNOME apps
apt remove -y --purge \
    thunderbird \
    rhythmbox \
    transmission-gtk \
    gnome-mines gnome-sudoku \
    aisleriot \
    cheese \
    shotwell \
    simple-scan \
    libreoffice* \
    remmina*

# Setup 7STAROS branding
cat > /etc/os-release << 'EOF'
NAME="7STAROS"
ID=7staros
PRETTY_NAME="7STAROS GNOME Edition"
VERSION="1.0"
VERSION_ID="1.0"
VERSION_CODENAME=stellar
HOME_URL="https://7staros.org"
SUPPORT_URL="https://forum.7staros.org"
BUG_REPORT_URL="https://bugs.7staros.org"
LOGO=7staros-logo
UBUNTU_CODENAME=jammy
EOF

# Setup lsb-release
cat > /etc/lsb-release << 'EOF'
DISTRIB_ID=7STAROS
DISTRIB_RELEASE=1.0
DISTRIB_CODENAME=stellar
DISTRIB_DESCRIPTION="7STAROS GNOME Edition"
EOF

# Setup GRUB
sed -i 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="7STAROS"/g' /etc/default/grub
update-grub

# Create star package manager
cat > /usr/local/bin/star << 'EOF'
#!/bin/bash
# 7STAROS Package Manager
echo "╔══════════════════════════╗"
echo "║   7STAROS Package Manager║"
echo "╚══════════════════════════╝"
apt "$@"
EOF
chmod +x /usr/local/bin/star

# Setup default user (auto-login)
useradd -m -s /bin/bash staruser -G sudo,adm,dialout,cdrom,floppy,audio,dip,video,plugdev,netdev
echo "staruser:7staros" | chpasswd

# Setup auto-login (optional)
cat > /etc/gdm3/custom.conf << 'EOF'
[daemon]
AutomaticLoginEnable=true
AutomaticLogin=staruser
EOF

# Download wallpapers from your repo
apt install -y git
mkdir -p /usr/share/backgrounds/7staros
cd /usr/share/backgrounds/7staros
wget -q https://github.com/fakhlol/7STAROS/raw/main/wallpapers/default/7star-1.jpg
wget -q https://github.com/fakhlol/7STAROS/raw/main/wallpapers/default/7star-2.jpg

# Set default wallpaper
cat > /usr/share/glib-2.0/schemas/10_7staros.gschema.override << 'EOF'
[org.gnome.desktop.background]
picture-uri='file:///usr/share/backgrounds/7staros/7star-1.jpg'
picture-options='zoom'
[org.gnome.desktop.screensaver]
picture-uri='file:///usr/share/backgrounds/7staros/7star-2.jpg'
EOF
glib-compile-schemas /usr/share/glib-2.0/schemas/

# Cleanup
apt autoremove -y
apt clean
rm -rf /var/lib/apt/lists/*

echo ""
echo "=== SETUP COMPLETE ==="
echo "7STAROS GNOME Edition ready!"
echo "Click 'Generate' in Cubic to build ISO"