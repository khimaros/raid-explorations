#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

mdadm --stop ${BOOT_MD_DEVICE} || true

vgchange -a n vg0 || true

cryptsetup luksClose ${ROOT_CRYPT_NAME} || true

mdadm --stop ${ROOT_MD_DEVICE} || true

for disk in "${DISKS[@]}"; do
    integritysetup close ${disk}${DISKS_PART_PREFIX}3_int || true
done
