#!/usr/bin/env bash

USER=chase

LOADER_CONF="$(ls /boot/loader/entries/*.conf)"
sed -i "$ s/$/nvidia-drm.modeset=1 nowatchdog/" "$LOADER_CONF"
sed -i "s/title Arch\ Linux (linux)/title Arch/" "$LOADER_CONF"

sed -i "s/timeout 3/timeout 0/" /boot/loader/loader.conf
sed -i "s/# console-mode keep/console-mode auto/" /boot/loader/loader.conf

# https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend
echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" >/etc/modprobe.d/nvidia-power-management.conf

systemctl enable nvidia-suspend.service
systemctl enable nvidia-hibernate.service

rsync -aAX -e 'ssh -p 2121' $USER@10.13.13.11:/mnt/user/Chase/arch/ /home/$USER

echo "Done! Remove custom_arch_install"
