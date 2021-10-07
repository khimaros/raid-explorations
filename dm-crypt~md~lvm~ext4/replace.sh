#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for dev in "${REPLACE_BOOT_DEVICES[@]}"; do
    mdadm --zero-superblock "$dev" || true
    mdadm --add ${BOOT_MD_DEVICE} "$dev"
done

mdadm --wait ${BOOT_MD_DEVICE}

for dev in "${REPLACE_CRYPT_DEVICES[@]}"; do
    mdadm --zero-superblock "$dev" || true
    mdadm --add ${ROOT_MD_DEVICE} "$dev"
done

mdadm --wait ${ROOT_MD_DEVICE}
