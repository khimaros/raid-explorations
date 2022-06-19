#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/../options.sh"
. "$(dirname "$0")/common.sh"

#umount /mnt/boot || true

umount /mnt || true

zpool export -a || true

zpool destroy rpool || true

#zpool destroy bpool || true

for dev in "${CRYPT_NAMES[@]}"; do
    cryptsetup luksClose ${dev} || true
done
