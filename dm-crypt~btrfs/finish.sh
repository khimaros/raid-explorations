#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

uuid=$(blkid -s PARTUUID -o value ${DISKS_DEVICES}${DISKS_PART_PREFIX}2)
echo "PARTUUID=${uuid} /boot ext4 rw,relatime 0 0" > /mnt/etc/fstab

chroot /mnt apt install -y keyutils

for disk in "${DISKS[@]}"; do
    uuid=$(blkid -s UUID -o value /dev/${disk}${DISKS_PART_PREFIX}3)
    echo "${disk}${DISKS_PART_PREFIX}3_crypt UUID=${uuid} none luks,discard,keyscript=decrypt_keyctl"
done > /mnt/etc/crypttab

chroot /mnt grep btrfs /proc/self/mounts >> /mnt/etc/fstab

chroot /mnt update-initramfs -c -k all
