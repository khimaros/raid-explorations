#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

mount --rbind /dev /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /run /mnt/run

mkdir -p /mnt/boot
mount ${DISKS_DEVICES}${DISKS_PART_PREFIX}2 /mnt/boot

if [[ "$BOOT_MODE" = "efi" ]]; then
    mkdir -p /mnt/boot/efi

    #for disk in "${DISKS_DEVICES[@]}"; do
    #    mount ${disk}${DISKS_PART_PREFIX}1 /mnt/boot/efi
    #    chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --no-nvram --recheck --no-floppy
    #    umount /mnt/boot/efi
    #done

    mount ${DISKS_DEVICES}${DISKS_PART_PREFIX}1 /mnt/boot/efi
fi

