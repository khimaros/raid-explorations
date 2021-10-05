#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for dev in "${REPLACE_BOOT_DEVICES[@]}"; do
    mdadm --zero-superblock "$dev" || true
    mdadm --add /dev/${BOOT_MD} "$dev"
done

for dev in "${REPLACE_ROOT_DEVICES[@]}"; do
    mdadm --zero-superblock "$dev" || true
    mdadm --add /dev/${ROOT_MD} "$dev"
done

mdadm --wait /dev/${BOOT_MD}

mdadm --wait /dev/${ROOT_MD}
