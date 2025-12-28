#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/loading.sh"

USER_NAME="${SUDO_USER:-$USER}"

typing_effect "Configuring system services..." "$CYAN"

enable_service() {
    systemctl enable "$1" --now
}

# ---------------- SERVICES ----------------
enable_service NetworkManager
enable_service bluetooth
enable_service cups
enable_service ufw
enable_service fstrim.timer
timedatectl set-ntp true

# ---------------- FIREWALL ----------------
typing_effect "Configuring firewall (UFW)..." "$YELLOW"
ufw --force reset
ufw default deny incoming
ufw default deny outgoing
ufw allow out 80
ufw allow out 443
ufw allow out 53
ufw enable
ufw reload

# ---------------- FLATPAK ----------------
typing_effect "Configuring Flatpak..." "$BLUE"
flatpak remote-add --if-not-exists flathub \
https://flathub.org/repo/flathub.flatpakrepo

# ---------------- AUR / YAY ----------------
#typing_effect "Installing YAY (AUR helper)..." "$PURPLE"
#if ! command -v yay &>/dev/null; then
#    sudo -u "$USER_NAME" git clone https://aur.archlinux.org/yay.git /tmp/yay
#    cd /tmp/yay
#    sudo -u "$USER_NAME" makepkg -si --noconfirm
#fi

success "System configuration completed."

