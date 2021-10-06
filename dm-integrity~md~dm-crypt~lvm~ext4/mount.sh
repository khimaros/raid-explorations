#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    integritysetup open "${INTEGRITYSETUP_OPTS[@]}" /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_int
done

while [[ ! -b ${ROOT_MD_DEVICE} ]]; do sleep 1; done
#mdadm --run ${ROOT_MD_DEVICE}

cryptsetup luksOpen ${ROOT_MD_DEVICE} ${ROOT_CRYPT_NAME}

while [[ ! -b /dev/vg0/root ]]; do sleep 1; done

#vgchange -a y vg0

mount /dev/vg0/root /mnt

mkdir -p /mnt/boot

mount ${BOOT_MD_DEVICE} /mnt/boot
