#!/bin/bash

set -ex

. ./config.sh
. ./options.sh
. ./${RAID_EXPLORATION}/common.sh

if [[ -n "$REPLACE_MODE" ]]; then
  DISKS=("${REPLACE_DISKS[@]}")
  DISKS_DEVICES=("${REPLACE_DISKS_DEVICES[@]}")
fi

wipefs -a "${DISKS_DEVICES[@]}"

sync "${DISKS_DEVICES[@]}"

for disk in "${DISKS[@]}"; do
    dev=/dev/$disk
    if [[ "$BOOT_MODE" = "efi" ]]; then
        sgdisk --zap-all $dev
        sgdisk -n1:1M:+512M -t1:EF00 $dev
        sgdisk -n2:0:+512M -t2:8301 $dev
        sgdisk -n3:0:0 -t3:8301 $dev
    else
        sgdisk --zap-all $dev
        sgdisk -n1:1M:+16M -t1:EF02 $dev
        sgdisk -n2:0:+512M -t2:8301 $dev
        sgdisk -n3:0:0 -t3:8301 $dev
    fi
done
