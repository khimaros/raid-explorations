#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

chroot /mnt apt install -y keyutils

for disk in "${DISKS[@]}"; do
    uuid=$(blkid -s UUID -o value /dev/${disk}${DISKS_PART_PREFIX}3)
    echo "${disk}${DISKS_PART_PREFIX}3_crypt UUID=${uuid} none luks,discard,keyscript=decrypt_keyctl"
done > /mnt/etc/crypttab

# Backup the LUKS headers onto /boot
mkdir -p /mnt/boot/luks/
for disk in "${DISKS[@]}"; do
    dev="/dev/${disk}3"
    cryptsetup luksHeaderBackup ${dev} --header-backup-file /mnt/boot/luks/${disk}3-headers.bin
done

chroot /mnt grep btrfs /proc/self/mounts >> /mnt/etc/fstab

chroot /mnt update-initramfs -c -k all
