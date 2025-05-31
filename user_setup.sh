#!/usr/bin/env bash

TEMP_DIR=temp
mkdir -p $TEMP_DIR

install_paru() {
    if ! command -v paru >/dev/null 2>&1; then
        sudo pacman -S --needed base-devel
        git clone https://aur.archlinux.org/paru.git
        cd paru || exit
        makepkg -si
        cd ../

        if [ -f "/etc/makepkg.conf" ]; then
            sed -i "s/^BUILDENV=.*/BUILDENV=(\!distcc color ccache check \!sign)/g" ./makepkg.conf
        else
            echo "Error: $MAKEPKG_CONF file not found."
        fi
    fi
    echo "Paru installed"
}

install_noconfirm() {
    if ! command -v rustc >/dev/null 2>&1; then
        sudo pacman --noconfirm -S rust firefox
    fi
    echo "noconfirms installed"
}

install_packages() {
    # Install updatespac
    sudo pacman -Syu

    cd $TEMP_DIR || exit 1
    install_paru
    install_noconfirm
    cd ../

    paru -S --needed - <user_installed_packages.txt

    # clean up
    rm -rf $TEMP_DIR
    paru -Qtdq | paru -Rns -
}

install_py_packages() {
    pip install -r ./pip/requirements.txt
}

start_services() {
    systemctl enable bluetooth
}

set_up_swap() {
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

install_etc_conf() {
    cp .config/sddm/kde_settings.conf /etc/sddm.conf.d/
}

# For flashing ESPs
# https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/establish-serial-connection.html#linux-dialout-group
add_user_to_uucp() {
    echo "Adding $USER to uucp group"
    sudo usermod -a -G uucp "$USER"
}

install_etc_conf

install_packages

install_py_packages

start_services

set_up_swap

add_user_to_uucp
