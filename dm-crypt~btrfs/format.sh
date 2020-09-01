#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    cryptsetup -q luksFormat -c aes-xts-plain64 -s 512 -h sha256 /dev/${disk}3
    cryptsetup luksOpen /dev/${disk}3 ${disk}3_crypt
done

mkfs.btrfs -f -m ${RAID_LEVEL} -d ${RAID_LEVEL} "${CRYPT_DEVICES[@]}"

mount ${CRYPT_DEVICES} /mnt

btrfs balance start --full-balance /mnt

btrfs scrub start -B /mnt
