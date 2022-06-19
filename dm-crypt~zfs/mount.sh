#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    cryptsetup luksOpen /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_crypt
done

modprobe zfs

zfs mount rpool/ROOT/debian

#mount ${DISK_DEVICES[0]}${DISKS_PART_PREFIX}2 /mnt/boot
