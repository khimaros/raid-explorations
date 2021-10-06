#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    cryptsetup luksOpen /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_crypt
done

while [[ ! -b ${ROOT_MD_DEVICE} ]]; do sleep 1; done
#mdadm --run ${ROOT_MD_DEVICE}

while [[ ! -b /dev/vg0/root ]]; do sleep 1; done

#vgchange -a y vg0

mount /dev/vg0/root /mnt

mdadm --assemble --name=${BOOT_MD_NAME} ${BOOT_MD_DEVICE}

mkdir -p /mnt/boot

mount ${BOOT_MD_DEVICE} /mnt/boot
