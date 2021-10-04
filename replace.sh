#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

if [[ -z "$REPLACE_DISKS_GLOB" ]]; then
    echo "[!!] you MUST specify REPLACE_DISKS_GLOB before execution"
    exit 1
fi

./remove.sh

./partition.sh

if [[ "$BOOT_MODE" = "efi" ]]; then
		for dev in "${REPLACE_EFI_DEVICES[@]}"; do
        mdadm --add /dev/md0 "$dev"
    done
fi

if [[ -f "./${RAID_EXPLORATION}/clone.sh" ]]; then
    ./${RAID_EXPLORATION}/clone.sh
fi

./${RAID_EXPLORATION}/map.sh

./${RAID_EXPLORATION}/replace.sh

for ((i=${#REPLACE_DISKS_DEVICES[@]}-1; i>=0; i--)); do
    disk="${REPLACE_DISKS_DEVICES[$i]}"
    if [[ "$BOOT_MODE" = "efi" ]]; then
        label="debian-${disk##/dev/}"
        efibootmgr -c -g -d ${disk} -p 1 -L "$label" -l '\EFI\debian\grubx64.efi'
    else
        grub-install ${disk}
    fi
done

./status.sh
