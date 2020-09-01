#!/bin/bash

set -ex

. "$(dirname "$0")/config.sh"

for disk in "${DISKS[@]}"; do
    cryptsetup -q luksFormat -c aes-xts-plain64 -s 512 -h sha256 /dev/${disk}3
    cryptsetup luksOpen /dev/${disk}3 ${disk}3_crypt
done

modprobe zfs

zpool create \
    -o ashift=12 \
    -O acltype=posixacl -O canmount=off -O compression=lz4 \
    -O dnodesize=auto -O normalization=formD -O relatime=on \
    -O xattr=sa -O mountpoint=/ -R /mnt \
    rpool $RAID_LEVEL "${CRYPT_DEVICES[@]}"

zfs create -o canmount=off -o mountpoint=none rpool/ROOT

zfs create -o canmount=noauto -o mountpoint=/ rpool/ROOT/debian

zfs mount rpool/ROOT/debian

