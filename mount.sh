#!/bin/bash

set -ex

. ./config.sh
. ./options.sh
. ./${RAID_EXPLORATION}/common.sh

mkdir -p /mnt/boot

if [[ -n "$RESCUE_MODE" ]]; then
    ln -sf /dev/md127 /dev/md/boot
fi

#mdadm --assemble --name=${BOOT_MD_NAME} ${BOOT_MD_DEVICE} || true

mount ${BOOT_MD_DEVICE} /mnt/boot

#mount ${BOOT_DEVICES} /mnt/boot

if [[ "$BOOT_MODE" = "efi" ]]; then
    mkdir -p /mnt/boot/efi

    mdadm --assemble --name=${EFI_MD_NAME} ${EFI_MD_DEVICE} || true

    mount ${EFI_MD_DEVICE} /mnt/boot/efi
fi
