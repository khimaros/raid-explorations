#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

mkfs.ext4 -F -m 0 ${DISK_DEVICES[0]}${DISKS_PART_PREFIX}2

for disk in "${DISKS[@]}"; do
    cryptsetup -q luksFormat "${CRYPTSETUP_OPTS[@]}" /dev/${disk}${DISKS_PART_PREFIX}3
done

for disk in "${DISKS[@]}"; do
    cryptsetup luksOpen /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_crypt
done

mkfs.btrfs -f --csum sha256 -m ${RAID_METADATA_LEVEL:-${RAID_LEVEL}} -d ${RAID_LEVEL} "${CRYPT_DEVICES[@]}"

mount ${CRYPT_DEVICES} /mnt

btrfs balance start --full-balance /mnt

btrfs scrub start -B /mnt

mkdir /mnt/boot

mount ${DISK_DEVICES[0]}${DISKS_PART_PREFIX}2 /mnt/boot
