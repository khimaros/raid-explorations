#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

chroot /mnt apt purge -y os-prober

if [[ "$BOOT_MODE" = "efi" ]]; then
    chroot /mnt apt install -y grub-efi-amd64 shim-signed
else
    chroot /mnt apt install -y grub-pc
fi

if [[ "$BOOT_MODE" = "efi" ]]; then
    chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --no-nvram --recheck --no-floppy
else
    chroot /mnt dpkg-reconfigure grub-pc
fi

chroot /mnt update-initramfs -c -k all

chroot /mnt update-grub
