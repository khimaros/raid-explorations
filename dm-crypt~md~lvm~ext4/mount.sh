#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/../options.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    echo "$CRYPT_PASSWORD" | cryptsetup luksOpen /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_crypt || true
done

#mdadm --assemble --name=${ROOT_MD_NAME} ${ROOT_MD_DEVICE} || true

while [[ ! -e ${ROOT_MD_DEVICE} ]]; do sleep 1; done

#vgchange -a y vg0

while [[ ! -b /dev/vg0/root ]]; do sleep 1; done

mount /dev/vg0/root /mnt

#mdadm --assemble --name=${BOOT_MD_NAME} ${BOOT_MD_DEVICE}

#while [[ ! -e ${BOOT_MD_DEVICE} ]]; do sleep 1; done

#mkdir -p /mnt/boot

#mount ${BOOT_MD_DEVICE} /mnt/boot
