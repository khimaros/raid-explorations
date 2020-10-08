#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    integritysetup open --integrity sha256 /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_int
done

while [[ ! -b /dev/md0 ]]; do sleep 1; done

cryptsetup luksOpen /dev/md0 md0_crypt

while [[ ! -b /dev/vg0/root ]]; do sleep 1; done

#vgchange -a y vg0

mount /dev/vg0/root /mnt
