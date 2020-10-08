#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

umount /mnt

vgchange -a n vg0

cryptsetup luksClose md0_crypt

mdadm --stop /dev/md0

for disk in "${DISKS[@]}"; do
    integritysetup close ${disk}${DISKS_PART_PREFIX}3_int
done
