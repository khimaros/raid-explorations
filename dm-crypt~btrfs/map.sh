#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

if [[ -n "$REPLACE_MODE" ]]; then
  DISKS=("${REPLACE_DISKS[@]}")
fi

for disk in "${DISKS[@]}"; do
    dev="/dev/${disk}${DISKS_PART_PREFIX}3"

    cryptsetup -q luksFormat "${CRYPTSETUP_OPTS[@]}" "$dev"

    if [[ -n "$REPLACE_MODE" ]]; then
        crypttab_uuid=$(grep "${disk}${DISKS_PART_PREFIX}3_crypt" /etc/crypttab | awk '{ print $2 }' | cut -d= -f2)
        if [[ -n "$crypttab_uuid" ]]; then
            cryptsetup -q luksUUID --uuid "$crypttab_uuid" "$dev"
        fi
    fi
done

for disk in "${DISKS[@]}"; do
    cryptsetup luksOpen /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_crypt
done
