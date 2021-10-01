#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

mdadm --zero-superblock "${BOOT_DEVICES[@]}"

mdadm --create --metadata=1.0 --level=1 --raid-devices=4 --bitmap=internal /dev/${BOOT_MD} "${BOOT_DEVICES[@]}"

mkfs.ext4 -m 0 /dev/${BOOT_MD}

for disk in "${DISKS[@]}"; do
    integritysetup format --batch-mode --integrity sha256 /dev/${disk}${DISKS_PART_PREFIX}3
done

for disk in "${DISKS[@]}"; do
    integritysetup open --integrity sha256 /dev/${disk}${DISKS_PART_PREFIX}3 ${disk}${DISKS_PART_PREFIX}3_int
done

mdadm --zero-superblock "${ROOT_DEVICES[@]}"

mdadm --create --level=${RAID_LEVEL} --raid-devices=4 --bitmap=internal /dev/${ROOT_MD} "${ROOT_DEVICES[@]}"

cryptsetup -q luksFormat "${CRYPTSETUP_OPTS[@]}" /dev/${ROOT_MD}

cryptsetup luksOpen /dev/${ROOT_MD} ${ROOT_MD}_crypt

pvcreate /dev/mapper/${ROOT_MD}_crypt

vgcreate vg0 /dev/mapper/${ROOT_MD}_crypt

lvcreate --extents=90%FREE --name=root vg0

mkfs.ext4 -m 0 /dev/vg0/root

mount /dev/vg0/root /mnt

mkdir /mnt/boot

mount /dev/${BOOT_MD} /mnt/boot
