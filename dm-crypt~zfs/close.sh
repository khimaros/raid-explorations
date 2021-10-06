#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

zpool destroy rpool || true

zpool destroy bpool || true

for dev in "${CRYPT_NAMES[@]}"; do
    cryptsetup luksClose ${dev} || true
done
