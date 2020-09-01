#!/bin/bash

set -ex

. "$(dirname "$0")/config.sh"

chroot /mnt apt install -y zfs-initramfs keyutils

for disk in "${DISKS[@]}"; do
    uuid=$(blkid -s UUID -o value /dev/${disk}3)
    echo "${disk}3_crypt UUID=${uuid} none luks,discard,initramfs,keyscript=decrypt_keyctl"
done > /mnt/etc/crypttab

echo REMAKE_INITRD=yes > /mnt/etc/dkms/zfs.conf

chroot /mnt update-initramfs -u -k all

cat <<EOF > /mnt/etc/default/grub.d/zfs.cfg
GRUB_CMDLINE_LINUX="root=ZFS=rpool/ROOT/debian"
EOF

chroot /mnt update-grub

chroot /mnt zpool export -a
