#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

mount --rbind /dev /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /run /mnt/run

#mkdir -p /mnt/boot
#mount ${DISKS_DEVICES}${DISKS_PART_PREFIX}2 /mnt/boot

if [[ "$BOOT_MODE" = "efi" ]]; then
    mkdir -p /mnt/boot/efi
    mount /dev/md0 /mnt/boot/efi
fi

