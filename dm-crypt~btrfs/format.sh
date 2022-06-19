#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/../options.sh"
. "$(dirname "$0")/common.sh"

mkfs.btrfs -f --csum sha256 -m ${RAID_METADATA_LEVEL:-${RAID_LEVEL}} -d ${RAID_LEVEL} "${CRYPT_DEVICES[@]}"

mount ${CRYPT_DEVICES} /mnt

btrfs balance start --full-balance /mnt

btrfs scrub start -B /mnt

#mkfs.btrfs -f --csum sha256 -m raid1c3 -d raid1c3 "${BOOT_DEVICES[@]}"
