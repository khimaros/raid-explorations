#!/bin/bash

set -ex

. ./config.sh
. ./options.sh
. ./${RAID_EXPLORATION}/common.sh

mdadm --zero-superblock "${BOOT_DEVICES[@]}" || true

yes | mdadm --create --name=${BOOT_MD_NAME} "${MDADM_BOOT_OPTS[@]}" ${BOOT_MD_DEVICE} "${BOOT_DEVICES[@]}"

wipefs -a ${BOOT_MD_DEVICE}

mkfs.ext4 -m 0 ${BOOT_MD_DEVICE}

#for dev in "${BOOT_DEVICES[@]}"; do
#    wipefs -a ${dev}
#    mkfs.ext4 -m 0 ${dev}
#done

if [[ "$BOOT_MODE" = "efi" ]]; then
    mdadm --zero-superblock "${EFI_DEVICES[@]}" || true

    mdadm --create --name=${EFI_MD_NAME} "${MDADM_BOOT_OPTS[@]}" ${EFI_MD_DEVICE} "${EFI_DEVICES[@]}"

    wipefs -a ${EFI_MD_DEVICE}

    mkfs.msdos -F 32 -s 1 -n EFI ${EFI_MD_DEVICE}
fi

./${RAID_EXPLORATION}/format.sh
