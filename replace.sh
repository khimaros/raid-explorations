#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

# IMPORTANT: Update DISKS_GLOB in config.sh before running.

./partition.sh

for disk in "${DISK_DEVICES[@]}"; do
    mdadm --fail /dev/md0 $disk || true
    mdadm --remove /dev/md0 $disk || true
done

if [[ "$BOOT_MODE" = "efi" ]]; then
    EFI_DEVICES=($(eval echo "/dev/${DISKS_GLOB}${DISKS_PART_PREFIX}1"))
		for dev in "${EFI_DEVICES[@]}"; do
        mdadm --add /dev/md0 "$dev"
    done
fi

./${RAID_EXPLORATION}/map.sh

./${RAID_EXPLORATION}/replace.sh

for ((i=${#DISKS_DEVICES[@]}-1; i>=0; i--)); do
    disk="${DISKS_DEVICES[$i]}"
    if [[ "$BOOT_MODE" = "efi" ]]; then
        label="debian-${disk##/dev/}"
        efibootmgr -c -g -d ${disk} -p 1 -L "$label" -l '\EFI\debian\grubx64.efi'
    else
        grub-install ${disk}
    fi
done
