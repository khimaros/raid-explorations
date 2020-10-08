#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    cryptsetup luksOpen /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_crypt
done

mount ${CRYPT_DEVICES} /mnt
