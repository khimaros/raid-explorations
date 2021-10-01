#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    integritysetup open --integrity sha256 /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_int
done

while [[ ! -b /dev/${ROOT_MD} ]]; do sleep 1; done

cryptsetup luksOpen /dev/${ROOT_MD} ${ROOT_MD}_crypt

while [[ ! -b /dev/vg0/root ]]; do sleep 1; done

#vgchange -a y vg0

mount /dev/vg0/root /mnt

mount /dev/${BOOT_MD} /mnt/boot
