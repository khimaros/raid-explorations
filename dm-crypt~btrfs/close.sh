#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    cryptsetup luksClose ${disk}${DISKS_PART_PREFIX}3_crypt
done
