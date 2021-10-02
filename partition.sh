#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

apt install -y gdisk dosfstools

wipefs -a "${DISKS_DEVICES[@]}"

sync "${DISKS_DEVICES[@]}"

for disk in "${DISKS_DEVICES[@]}"; do
    sgdisk --zap-all $disk

    sgdisk -n1:1M:+512M -t1:EF00 $disk
    sgdisk -n2:0:+512M -t2:8301 $disk
    sgdisk -n3:0:0 -t3:8301 $disk

    #parted $disk mktable gpt
    #parted $disk mkpart primary fat32 1MiB 513MiB
    #parted $disk set 1 esp on
    #parted $disk mkpart primary ext4 513MiB 1024MiB
    #parted $disk mkpart primary 1024MiB 100%
done
