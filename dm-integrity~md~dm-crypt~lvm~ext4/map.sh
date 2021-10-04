#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

if [[ -n "$REPLACE_DISKS_GLOB" ]]; then
  DISKS=("${REPLACE_DISKS[@]}")
fi

for disk in "${DISKS[@]}"; do
    integritysetup format --batch-mode --sector-size=4096 "${INTEGRITYSETUP_OPTS[@]}" /dev/${disk}${DISKS_PART_PREFIX}3
done

for disk in "${DISKS[@]}"; do
    integritysetup open "${INTEGRITYSETUP_OPTS[@]}" /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_int
done
