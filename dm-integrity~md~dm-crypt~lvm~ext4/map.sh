#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    integritysetup format --batch-mode "${INTEGRITYSETUP_OPTS[@]}" /dev/${disk}${DISKS_PART_PREFIX}3
done

for disk in "${DISKS[@]}"; do
    integritysetup open "${INTEGRITYSETUP_OPTS[@]}" /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_int
done
