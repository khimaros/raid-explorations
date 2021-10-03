#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

apt install -y gdisk dosfstools

wipefs -a "${DISKS_DEVICES[@]}"

sync "${DISKS_DEVICES[@]}"

for disk in "${DISKS[@]}"; do
    dev=/dev/$disk
    sgdisk --zap-all $dev

    sgdisk -n1:1M:+512M -t1:EF00 $dev
    sgdisk -n2:0:+512M -t2:8301 $dev
    sgdisk -n3:0:0 -t3:8301 $dev

    crypttab_uuid=$(grep "${disk}${DISKS_PART_PREFIX}3_crypt" /etc/crypttab | awk '{ print $2 }' | cut -d= -f2)
    if [[ -n "$crypttab_uuid" ]]; then
        sgdisk -u3:$crypttab_uuid $dev
    fi
done
