#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/../options.sh"
. "$(dirname "$0")/common.sh"

#for dev in "${REPLACE_BOOT_DEVICES[@]}"; do
#    btrfs device add $dev /boot
#    btrfs device remove missing /boot
#done

#btrfs balance start --full-balance /boot

for dev in "${REPLACE_CRYPT_DEVICES[@]}"; do
    #missing_devid=$(btrfs device usage / | grep "missing, ID: " | head -n 1 | awk '{ print $3 }')
    #btrfs replace start -B -r ${missing_devid} $dev /

    btrfs device add $dev /
    btrfs device remove missing /
done

btrfs balance start --full-balance -dconvert=${RAID_LEVEL},soft -mconvert=${RAID_METADATA_LEVEL},soft /
