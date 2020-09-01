#!/bin/bash

set -ex

. "$(dirname "$0")/config.sh"

chroot /mnt apt install -y keyutils

for disk in "${DISKS[@]}"; do
    uuid=$(blkid -s UUID -o value /dev/${disk}3)
    echo "${disk}3_crypt UUID=${uuid} none luks,discard,keyscript=decrypt_keyctl"
done > /mnt/etc/crypttab

chroot /mnt update-initramfs -u -k all

