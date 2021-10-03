#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

mdadm --zero-superblock --metadata=1.0 "${BOOT_DEVICES[@]}" || true

mdadm --create --metadata=1.0 --level=1 --raid-devices=4 --bitmap=internal /dev/${BOOT_MD} "${BOOT_DEVICES[@]}"

wipefs -a /dev/${BOOT_MD}

mkfs.ext4 -m 0 /dev/${BOOT_MD}

mdadm --zero-superblock "${ROOT_DEVICES[@]}" || true

mdadm --create --level=${RAID_LEVEL} --raid-devices=4 --bitmap=internal /dev/${ROOT_MD} "${ROOT_DEVICES[@]}"

wipefs -a /dev/${ROOT_MD}

cryptsetup -q luksFormat --sector-size=4096 "${CRYPTSETUP_OPTS[@]}" /dev/${ROOT_MD}

cryptsetup luksOpen /dev/${ROOT_MD} ${ROOT_MD}_crypt

pvcreate /dev/mapper/${ROOT_MD}_crypt

vgcreate vg0 /dev/mapper/${ROOT_MD}_crypt

lvcreate --extents=90%FREE --name=root vg0

mkfs.ext4 -m 0 /dev/vg0/root

mount /dev/vg0/root /mnt

mkdir /mnt/boot

mount /dev/${BOOT_MD} /mnt/boot
