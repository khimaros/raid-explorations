#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    integritysetup format --batch-mode --integrity sha256 /dev/${disk}3
    integritysetup open --integrity sha256 /dev/${disk}3 ${disk}3_int
done

mdadm --create --level=${RAID_LEVEL} --raid-devices=4 --bitmap=internal /dev/md0 "${INTEGRITY_DEVICES[@]}"

cryptsetup luksFormat -q /dev/md0

cryptsetup luksOpen /dev/md0 md0_crypt

pvcreate /dev/mapper/md0_crypt

vgcreate vg0 /dev/mapper/md0_crypt

lvcreate --extents=90%FREE --name=root vg0

mkfs.ext4 -m 0 /dev/vg0/root

mount /dev/vg0/root /mnt
