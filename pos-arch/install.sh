#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# ARCH LINUX POST-INSTALL SCRIPT
# Author : Gabriel Jesus
# =========================================================

# ---------------- PATH RESOLUTION ----------------
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$ROOT_DIR/script"

# ---------------- LOAD UI / HELPERS ----------------
source "$SCRIPT_DIR/loading.sh"

clear
banner

typing_effect "ARCH LINUX POST-INSTALLATION" "$BLUE"
typing_effect "Created by GABRIEL JESUS" "$PURPLE"
typing_effect "PERSONAL USE ONLY" "$YELLOW"
echo

typing_effect "
This script will install packages
and apply system configurations.

Use at your own risk.
" "$CYAN"

center_text "Press ENTER to continue" "$GREEN"
read -r

# ---------------- PRIVILEGE CHECK ----------------
require_root

clear
banner
typing_effect "Starting post-install process..." "$GREEN"
sleep 1

# ---------------- PACKAGE INSTALL ----------------
typing_effect "Installing packages..." "$CYAN"
echo

while read -r package; do
    # Skip empty lines and comments
    [[ -z "$package" || "$package" =~ ^# ]] && continue

    install_animation "$package"

    if pacman -S --needed --noconfirm "$package"; then
        center_text "Installed: $package" "$GREEN"
    else
        center_text "Skipping missing or failed package: $package" "$YELLOW"
        sleep 0.5
    fi
done < "$SCRIPT_DIR/programs.sh"

success "Package installation step finished."

# ---------------- SYSTEM CONFIG ----------------
if bash "$SCRIPT_DIR/config.sh"; then
    success "System configuration completed."
else
    center_text "System configuration finished with warnings." "$YELLOW"
fi

# ---------------- FINISH ----------------
echo
success "Post-installation completed."
typing_effect "Reboot recommended." "$GREEN"

