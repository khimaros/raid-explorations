#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/../options.sh"
. "$(dirname "$0")/common.sh"

for dev in "${REPLACE_CRYPT_DEVICES[@]}"; do
    mdadm --fail ${ROOT_MD_DEVICE} ${dev} || true
    mdadm --remove ${ROOT_MD_DEVICE} ${dev} || true
done

for disk in "${REPLACE_DISKS[@]}"; do
    integritysetup close "${disk}3_int" || true
done
