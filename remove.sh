#!/bin/bash

set -ex

. ./config.sh
. ./options.sh
. ./${RAID_EXPLORATION}/common.sh

for dev in "${REPLACE_BOOT_DEVICES[@]}"; do
    mdadm --fail ${BOOT_MD_DEVICE} ${dev} || true
    mdadm --remove ${BOOT_MD_DEVICE} ${dev} || true
done

if [[ "$BOOT_MODE" = "efi" ]]; then
    for dev in "${REPLACE_EFI_DEVICES[@]}"; do
        mdadm --fail ${EFI_MD_DEVICE} ${dev} || true
        mdadm --remove ${EFI_MD_DEVICE} ${dev} || true
    done
fi

if [[ -e ./${RAID_EXPLORATION}/remove.sh ]]; then
    ./${RAID_EXPLORATION}/remove.sh
fi

for disk in "${REPLACE_DISKS_DEVICES[@]}"; do
    wipefs -a "${disk}1" || true
    wipefs -a "${disk}2" || true
    wipefs -a "${disk}3" || true
done
