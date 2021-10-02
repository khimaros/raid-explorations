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
    chroot /mnt grub-install --target=x86_64-efi \
        --bootloader-id=debian \
        --efi-directory=/boot/efi --no-nvram --recheck --no-floppy
    for ((i=${#DISKS_DEVICES[@]}-1; i>=0; i--)); do
        disk="${DISKS_DEVICES[$i]}"
        label="debian-${disk##/dev/}"
        chroot /mnt efibootmgr -c -g -d ${disk} -p 1 -L "$label" -l '\EFI\debian\grubx64.efi'
    done
    echo "/dev/md0 /boot/efi vfat rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro 0 0" >> /mnt/etc/fstab
else
    chroot /mnt dpkg-reconfigure grub-pc
    for disk in "${DISK_DEVICES[@]}"; do
        chroot /mnt grub-install ${disk}
    done
fi

chroot /mnt update-initramfs -c -k all

chroot /mnt update-grub
