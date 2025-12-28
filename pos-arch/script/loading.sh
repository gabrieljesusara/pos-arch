#!/usr/bin/env bash
set -euo pipefail

# ================= COLORS =================
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
ORANGE='\033[38;5;214m'
NC='\033[0m'

COLORS=("$RED" "$ORANGE" "$YELLOW" "$GREEN" "$BLUE" "$PURPLE" "$CYAN")

# ================= TERMINAL =================
term_width() {
    tput cols
}

# ================= UI =================
center_text() {
    local text="$1"
    local color="${2:-$NC}"
    local width pad
    width=$(term_width)

    while IFS= read -r line; do
        pad=$(( (width - ${#line}) / 2 ))
        (( pad < 0 )) && pad=0
        printf "%*s%b%s%b\n" "$pad" "" "$color" "$line" "$NC"
    done <<< "$text"
}

typing_effect() {
    local text="$1"
    local color="${2:-$NC}"
    local width pad
    width=$(term_width)

    while IFS= read -r line; do
        pad=$(( (width - ${#line}) / 2 ))
        (( pad < 0 )) && pad=0
        printf "%*s" "$pad" ""
        for ((i=0; i<${#line}; i++)); do
            printf "%b%s%b" "$color" "${line:i:1}" "$NC"
            sleep 0.01
        done
        echo
    done <<< "$text"
}

banner() {
center_text "
⡹⣧⠀⠀⠀⠀⠀⠀⣼⣿⢱⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠶
⣿⣜⢧⡀⠀⠀⠀⠀⣿⡏⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣛⣥⣾⣷⣌
⣿⣿⣎⢷⡀⠀⠀⠀⣿⢨⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣛⣛⣻⣯⣭⣭⠭⣭⣷⣶⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣯⢧⠀⠀⠀⢸⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢟⣵⢾⣻⡿⠿⠿⣿⠋⣶⣷⠢⣾⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣎⢇⠀⠀⠈⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣡⡻⢃⠛⢉⣨⣽⣶⣶⣷⣮⣣⣶⣾⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⡞⡄⠀⠀⠀⢿⣿⣿⣿⣿⣿⡿⠿⡛⢻⣉⣭⣴⣶⣶⢆⣴⣯⣽⣿⣿⣿⣿⡿⠿⠿⣿⠿⠿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣷⢱⠀⠀⠀⠈⠿⣛⠫⣉⢢⣬⣦⣾⣿⣿⣿⡿⢟⢣⣟⣿⣿⢟⣻⣿⣿⣷⣾⣿⣿⣿⣿⣿⡶⠯⣝⣛⣛
⣿⣿⣿⣿⣿⣿⣇⡄⡠⢔⣢⣵⣾⣧⣿⡿⣿⣿⣿⣿⣿⣛⣯⠃⢟⠛⣍⣉⣭⣭⣿⣭⣭⣭⣭⣭⣭⣷⣶⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⢁⣾⣿⣿⣿⣿⣯⣶⣿⣟⣿⣽⣾⡿⢟⠵⣪⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⡏⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢟⡴⣡⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣭⡻⣿⣿⣿⣯⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢁⢎⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣮⢻⣿⣿⣿⣿⣿⡿⡛⠉⠁⠀⠀⠀⡞⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣧⠻⣿⣿⣿⣿⣾⣿⡄⠀⠀⠀⢠⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
" "$RED"
}

install_animation() {
    local pkg="$1"
    local width pad msg color
    width=$(term_width)
    msg="Installing: $pkg"

    for _ in {1..6}; do
        color=${COLORS[RANDOM % ${#COLORS[@]}]}
        pad=$(( (width - ${#msg}) / 2 ))
        (( pad < 0 )) && pad=0
        echo -ne "${color}\r$(printf "%*s" "$pad" "")$msg${NC}"
        sleep 0.12
    done
    echo
}

# ================= HELPERS =================
success() {
    center_text "✔ $1" "$GREEN"
}

error_exit() {
    center_text "ERROR: $1" "$RED"
    exit 1
}

require_root() {
    [[ $EUID -eq 0 ]] || error_exit "Run this script as root (sudo)."
}

