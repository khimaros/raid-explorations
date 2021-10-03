#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

chroot /mnt apt install -y keyutils

for disk in "${DISKS[@]}"; do
    uuid=$(blkid -s PARTUUID -o value /dev/${disk}${DISKS_PART_PREFIX}3)
    echo "${disk}${DISKS_PART_PREFIX}3_crypt PARTUUID=${uuid} none luks,discard,keyscript=decrypt_keyctl"
done > /mnt/etc/crypttab

chroot /mnt grep btrfs /proc/self/mounts >> /mnt/etc/fstab

chroot /mnt update-initramfs -c -k all
