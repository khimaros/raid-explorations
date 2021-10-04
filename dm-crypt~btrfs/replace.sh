#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for dev in "${REPLACE_BOOT_DEVICES[@]}"; do
    btrfs device add $dev /boot
    btrfs device remove missing /boot
done

for dev in "${REPLACE_CRYPT_DEVICES[@]}"; do
    btrfs device add $dev /
    btrfs device remove missing /
done
