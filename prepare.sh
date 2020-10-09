#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

[[ -n "${DEBIAN_BACKPORTS}" ]] && cat <<EOF > /etc/apt/sources.list.d/backports.list
deb http://deb.debian.org/debian/ ${DEBIAN_RELEASE}-backports main contrib
EOF

apt update && apt install -y "${EXTRA_PACKAGES[@]}"

apt install -y gdisk dosfstools "${RAID_PACKAGES[@]}"

#wipefs -a "${DISKS_DEVICES[@]}"
#sleep 1

for disk in "${DISKS_DEVICES[@]}"; do
    sgdisk --zap-all $disk

    sgdisk -n1:1M:+512M -t1:EF00 $disk
    sgdisk -n2:0:+512M -t2:8300 $disk
    sgdisk -n3:0:0 -t3:8301 $disk

    #parted $disk mktable gpt
    #parted $disk mkpart primary fat32 1MiB 513MiB
    #parted $disk set 1 esp on
    #parted $disk mkpart primary ext4 513MiB 1024MiB
    #parted $disk mkpart primary 1024MiB 100%

    mkfs.msdos -F 32 -s 1 -n EFI ${disk}${DISKS_PART_PREFIX}1
    mkfs.ext4 -F -m 0 ${disk}${DISKS_PART_PREFIX}2
done

apt install -y "${RAID_PACKAGES[@]}"
