#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

zpool create -f \
    -o ashift=12 \
    -O acltype=posixacl -O canmount=off -O compression=lz4 \
    -O dnodesize=auto -O normalization=formD -O relatime=on \
    -O xattr=sa -O mountpoint=/ -R /mnt \
    rpool $RAID_LEVEL "${CRYPT_DEVICES[@]}"

zfs create -o canmount=off -o mountpoint=none rpool/ROOT
zfs create -o canmount=noauto -o mountpoint=/ rpool/ROOT/debian

zfs mount rpool/ROOT/debian

mkdir /mnt/boot

zpool create -f \
    -o ashift=12 \
    -O acltype=posixacl -O canmount=off -O compression=lz4 \
    -O dnodesize=auto -O normalization=formD -O relatime=on \
    -O xattr=sa -O mountpoint=/boot -R /mnt \
    rpool mirror "${BOOT_DEVICES[@]}"

zfs create -o canmount=off -o mountpoint=none bpool/BOOT
zfs create -o canmount=noauto -o mountpoint=/boot bpool/BOOT/debian

zfs mount bpool/BOOT/debian
