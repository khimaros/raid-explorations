#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

if [[ -n "$REPLACE_DISKS_GLOB" ]]; then
  DISKS=("${REPLACE_DISKS[@]}")
fi

for disk in "${DISKS[@]}"; do
    cryptsetup -q luksFormat "${CRYPTSETUP_OPTS[@]}" /dev/${disk}${DISKS_PART_PREFIX}3
done

for disk in "${DISKS[@]}"; do
    cryptsetup luksOpen /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_crypt
done
