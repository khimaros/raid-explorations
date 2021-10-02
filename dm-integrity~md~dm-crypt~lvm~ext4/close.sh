#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

mdadm --stop /dev/${BOOT_MD} || true

vgchange -a n vg0 || true

cryptsetup luksClose ${ROOT_MD}_crypt || true

mdadm --stop /dev/${ROOT_MD} || true

for disk in "${DISKS[@]}"; do
    integritysetup close ${disk}${DISKS_PART_PREFIX}3_int || true
done
