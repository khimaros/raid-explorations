#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${REPLACE_DISKS[@]}"; do
    dev="/dev/${dev}"
    #btrfs device remove /
    cryptsetup luksClose "${disk}3_crypt" || true
done
