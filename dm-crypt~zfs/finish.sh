#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

chroot /mnt apt install -y zfs-initramfs keyutils

for disk in "${DISKS[@]}"; do
    uuid=$(blkid -s PARTUUID -o value /dev/${disk}${DISKS_PART_PREFIX}3)
    echo "${disk}${DISKS_PART_PREFIX}3_crypt PARTUUID=${uuid} none luks,discard,initramfs,keyscript=decrypt_keyctl"
done > /mnt/etc/crypttab

echo REMAKE_INITRD=yes > /mnt/etc/dkms/zfs.conf

cat <<EOF > /mnt/etc/default/grub.d/zfs.cfg
GRUB_CMDLINE_LINUX="root=ZFS=rpool/ROOT/debian"
EOF

chroot /mnt update-initramfs -c -k all

chroot /mnt update-grub

mount | grep -v zfs | tac | awk '/\/mnt/ {print $3}' | \
    xargs -i{} umount -lf {}

zpool export -a
