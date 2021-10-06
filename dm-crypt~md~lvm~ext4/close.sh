#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

mdadm --stop ${BOOT_MD_DEVICE} || true

vgchange -a n vg0 || true

mdadm --stop ${ROOT_MD_DEVICE} || true

for dev in "${CRYPT_NAMES[@]}"; do
    cryptsetup luksClose ${dev} || true
done
