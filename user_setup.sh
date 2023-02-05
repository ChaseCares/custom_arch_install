#!/usr/bin/env bash

TEMP_DIR=temp
mkdir -p $TEMP_DIR

function install_paru() {
    if ! command -v paru &>/dev/null; then
        sudo pacman -S --needed base-devel
        git clone https://aur.archlinux.org/paru.git
        cd paru || exit
        makepkg -si
        cd ../
    fi
    echo "Paru installed"
}

function install_rust() {
    if ! command -v rustc &>/dev/null; then
        sudo pacman --noconfirm -S rust
    fi
    echo "Rust installed"
}

function install_firefox() {
    if ! command -v firefox &>/dev/null; then
        sudo pacman --noconfirm -S firefox
    fi
    echo "Firefox installed"
}

function install_packages() {
    # Install updatespac
    sudo pacman -Syu

    cd $TEMP_DIR || exit 1
    install_rust
    install_paru
    install_firefox
    cd ../

    paru -S --needed - <user_installed_packages.txt

    # clean up
    rm -rf $TEMP_DIR
    paru -Qtdq | paru -Rns -
}

function install_py_packages() {
    pip install -r ./pip/requirements.txt
}

function start_services() {
    systemctl enable bluetooth
}

function set_up_swap() {
    swap="$(grep -e '/swap' /etc/mtab | grep -o '/dev/[[:alnum:]]\+')"
    if [[ -z "$swap" ]]; then
        echo "No swap partition found"
        return
    fi

    read -r -p "Do you want to format $swap? [y/N] " response && [[ $response == [yY] ]] || return

    sudo umount "$swap"
    sudo mkswap -L swap "$swap"
    sudo swapon "$swap"

    echo "Add the following to /etc/fstab"
    echo "UUID=$(blkid -s UUID -o value "$swap") none swap defaults 0 0"
}

function install_etc_conf() {
    cp .config/sddm/kde_settings.conf /etc/sddm.conf.d/
}

install_etc_conf

install_packages

install_py_packages

start_services

set_up_swap
