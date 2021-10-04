#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    crypttab_uuid=$(grep "${disk}${DISKS_PART_PREFIX}3_crypt" /etc/crypttab | awk '{ print $2 }' | cut -d= -f2)
    if [[ -n "$crypttab_uuid" ]]; then
        sgdisk -u3:$crypttab_uuid $dev
    fi
done
