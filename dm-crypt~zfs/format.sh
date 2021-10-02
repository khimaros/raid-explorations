#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

mkfs.ext4 -F -m 0 ${DISK_DEVICES[0]}${DISKS_PART_PREFIX}2

zpool create \
    -o ashift=12 \
    -O acltype=posixacl -O canmount=off -O compression=lz4 \
    -O dnodesize=auto -O normalization=formD -O relatime=on \
    -O xattr=sa -O mountpoint=/ -R /mnt \
    rpool $RAID_LEVEL "${CRYPT_DEVICES[@]}"

zfs create -o canmount=off -o mountpoint=none rpool/ROOT

zfs create -o canmount=noauto -o mountpoint=/ rpool/ROOT/debian

zfs mount rpool/ROOT/debian

mkdir /mnt/boot

mount ${DISK_DEVICES[0]}${DISKS_PART_PREFIX}2 /mnt/boot
