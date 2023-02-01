#!/usr/bin/env bash

SAVE_DIR="/home/chase/projects"
TXT_FILE="$SAVE_DIR/custom_arch_install/packages/user_installed_packages.txt"

pacman -Qqe >"$TXT_FILE"
chmod 666 "$TXT_FILE"

default_packages=()

while IFS= read -r line; do
    default_packages+=("$line")
done <"$SAVE_DIR/custom_arch_install/packages/default_installed_packages.txt"

for package in "${default_packages[@]}"; do
    sed -i "/$package/d" "$TXT_FILE"
done
