#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    cryptsetup -q luksFormat -c aes-xts-plain64 -s 512 -h sha256 /dev/${disk}${DISKS_PART_PREFIX}3
    cryptsetup luksOpen /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_crypt
done

mkfs.btrfs -f -m ${RAID_METADATA_LEVEL:-${RAID_LEVEL}} -d ${RAID_LEVEL} "${CRYPT_DEVICES[@]}"

mount ${CRYPT_DEVICES} /mnt

btrfs balance start --full-balance /mnt

btrfs scrub start -B /mnt
