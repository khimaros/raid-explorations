#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh


sed -i 's/ main/ main contrib/g' /etc/apt/sources.list

[[ -z "${DEBIAN_BACKPORTS}" ]] || cat <<EOF > /etc/apt/sources.list.d/backports.list
deb http://deb.debian.org/debian/ ${DEBIAN_RELEASE}-backports main contrib
EOF

apt update && apt install -y "${EXTRA_PACKAGES[@]}"

apt install -y mdadm gdisk dosfstools "${RAID_PACKAGES[@]}"

#wipefs -a "${DISKS_DEVICES[@]}"
#sleep 1

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

if test -b /dev/md/*; then
    for dev in /dev/md/*; do
        mdadm --stop $dev
    done
fi

EFI_DEVICES=($(eval echo "/dev/${DISKS_GLOB}${DISKS_PART_PREFIX}1"))

apt install -y "${RAID_PACKAGES[@]}" mdadm

mdadm --zero-superblock "${EFI_DEVICES[@]}"

mdadm --create /dev/md0 --metadata=1.0 --level=1 --raid-devices=4 --bitmap=internal "${EFI_DEVICES[@]}"

mkfs.msdos -F 32 -s 1 -n EFI /dev/md0
