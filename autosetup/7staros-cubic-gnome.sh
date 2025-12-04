#!/bin/bash
# 7STAROS Cubic GNOME Setup
# Save as: 7staros-cubic-gnome.sh
# Run in Cubic chroot: bash 7staros-cubic-gnome.sh

set -e

echo "╔══════════════════════════════════╗"
echo "║   7STAROS GNOME Builder          ║"
echo "║   Run this in Cubic Chroot       ║"
echo "╚══════════════════════════════════╝"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Step 1: Update
echo -e "${GREEN}[1/6] Updating system...${NC}"
apt update
apt upgrade -y

# Step 2: Install GNOME
echo -e "${GREEN}[2/6] Installing GNOME...${NC}"
apt install -y ubuntu-desktop-minimal gnome-shell gnome-terminal \
    nautilus gdm3 firefox-esr network-manager-gnome

# Step 3: Install tools
echo -e "${GREEN}[3/6] Installing tools...${NC}"
apt install -y nano curl wget git htop neofetch python3 docker.io

# Step 4: Remove bloat
echo -e "${GREEN}[4/6] Removing bloat...${NC}"
apt remove -y --purge snapd thunderbird rhythmbox
apt autoremove -y

# Step 5: Setup branding
echo -e "${GREEN}[5/6] Setting up branding...${NC}"
cat > /etc/os-release << 'EOF'
NAME="7STAROS"
ID=7staros
PRETTY_NAME="7STAROS GNOME Edition"
VERSION="1.0"
HOME_URL="https://7staros.org"
EOF

# Step 6: Finalize
echo -e "${GREEN}[6/6] Finalizing...${NC}"
useradd -m -s /bin/bash staruser -G sudo
echo "staruser:7staros" | chpasswd
update-grub

echo ""
echo -e "${YELLOW}╔══════════════════════════════════╗${NC}"
echo -e "${YELLOW}║    SETUP COMPLETE!              ║${NC}"
echo -e "${YELLOW}║   Now click GENERATE in Cubic   ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════╝${NC}"