#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

mkfs.btrfs -f --csum sha256 -m ${RAID_METADATA_LEVEL:-${RAID_LEVEL}} -d ${RAID_LEVEL} "${CRYPT_DEVICES[@]}"

mount ${CRYPT_DEVICES} /mnt

btrfs balance start --full-balance /mnt

btrfs scrub start -B /mnt

mkfs.ext4 -F -m 0 ${DISKS_DEVICES[0]}${DISKS_PART_PREFIX}2

mkdir /mnt/boot

mount ${DISKS_DEVICES[0]}${DISKS_PART_PREFIX}2 /mnt/boot
