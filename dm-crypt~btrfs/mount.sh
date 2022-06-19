#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/../options.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    echo "$CRYPT_PASSWORD" | cryptsetup luksOpen /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_crypt
done

mount ${CRYPT_DEVICES} /mnt

#mount ${BOOT_DEVICES} /mnt/boot
