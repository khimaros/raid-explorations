#!/bin/bash

set -ex

. config.sh
. default/common.sh

apt update && apt install -y "${EXTRA_PACKAGES[@]}"

apt install -y parted dosfstools mdadm "${RAID_PACKAGES[@]}"

wipefs -a "${DISKS_DEVICES[@]}"

sleep 1

for disk in "${DISKS_DEVICES[@]}"; do
    parted $disk mktable gpt
    parted $disk mkpart primary fat32 1MiB 513MiB
    parted $disk set 1 esp on
    parted $disk mkpart primary ext4 513MiB 1024MiB
    parted $disk mkpart primary 1024MiB 100%
    sleep 1
    mkfs.msdos -F 32 -s 1 -n EFI ${disk}1
    mkfs.ext4 -F -m 0 ${disk}2
done

apt install -y "${RAID_PACKAGES[@]}"