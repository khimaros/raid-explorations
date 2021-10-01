#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

mdadm --stop /dev/${BOOT_MD}

vgchange -a n vg0

cryptsetup luksClose ${ROOT_MD}_crypt

mdadm --stop /dev/${ROOT_MD}

for disk in "${DISKS[@]}"; do
    integritysetup close ${disk}${DISKS_PART_PREFIX}3_int
done
