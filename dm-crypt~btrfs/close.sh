#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/../options.sh"
. "$(dirname "$0")/common.sh"

umount /mnt || true

for dev in "${CRYPT_NAMES[@]}"; do
    cryptsetup luksClose ${dev} || true
done
