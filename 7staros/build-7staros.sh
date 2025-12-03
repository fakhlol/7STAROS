set -e

echo "[7IS] ============================================"
echo "[7IS]         7STAROS INSTALLATION SYSTEM"
echo "[7IS] ============================================"

if ! command -v mkarchiso &> /dev/null; then
    echo "[7IS] mkarchiso not found. Installing archiso..."
    sudo pacman -S --noconfirm archiso
else
    echo "[7IS] mkarchiso detected."
fi

WORKDIR="$HOME/7STAROS"
RELENG="$WORKDIR/archiso-releng"

echo "[7IS] Creating workspace at $WORKDIR..."
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"

echo "[7IS] Copying ArchISO releng profile..."
cp -r /usr/share/archiso/configs/releng "$RELENG"

echo "[7IS] Writing profiledef.sh..."
cat << 'EOF' > "$RELENG/profiledef.sh"
iso_name="7STAROS"
iso_label="7STAROS_$(date +%Y%m)"
iso_publisher="7STAROS Project"
iso_application="7STAROS Minimal Linux"
iso_version="1.0"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot')
EOF

echo "[7IS] Adding /etc/issue..."
mkdir -p "$RELENG/airootfs/etc"
cat << 'EOF' > "$RELENG/airootfs/etc/issue"
===================================
            7 S T A R O S
===================================
Minimal Arch-Based Linux
Type 'terx -H' for help.
EOF

echo "[7IS] Installing custom terx command..."
mkdir -p "$RELENG/airootfs/usr/local/bin"
cat << 'EOF' > "$RELENG/airootfs/usr/local/bin/terx"
#!/bin/bash

case "$1" in
    -H|--help)
        echo "========== 7STAROS TERX HELP =========="
        echo " terx -H       Show help menu"
        echo " terx -l       List available commands"
        ;;
    -l|--list)
        echo "========== 7STAROS COMMAND LIST =========="
        echo " terx -H"
        echo " terx -l"
        echo " reboot"
        echo " shutdown"
        ;;
    *)
        echo "Unknown argument. Use 'terx -H'."
        ;;
esac
EOF

chmod +x "$RELENG/airootfs/usr/local/bin/terx"

echo "[7IS] Building ISO..."
cd "$RELENG"
sudo mkarchiso -v .

echo "[7IS] ============================================"
echo "[7IS] BUILD COMPLETE"
echo "[7IS] ISO created in: $RELENG/out/"
