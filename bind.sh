#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

mount --rbind /dev /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /run /mnt/run

if [[ "$BOOT_MODE" = "efi" ]]; then
    mkdir -p /mnt/boot/efi
    mount /dev/md/efi /mnt/boot/efi
fi
