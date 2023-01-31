#!/usr/bin/env bash

USER=chase

LOADER_CONF="$(ls /boot/loader/entries/*.conf)"
sed -i "$ s/$/nvidia-drm.modeset=1/" "$LOADER_CONF"
sed -i "s/title Arch\ Linux (linux)/title Arch/" "$LOADER_CONF"

rsync -aAX -e 'ssh -p 2121' $USER@10.13.13.11:/mnt/user/Chase/arch/ /home/$USER
