#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

chroot /mnt apt install -y zfs-initramfs keyutils

for disk in "${DISKS[@]}"; do
    uuid=$(blkid -s UUID -o value /dev/${disk}${DISKS_PART_PREFIX}3)
    echo "${disk}${DISKS_PART_PREFIX}3_crypt UUID=${uuid} none luks,discard,initramfs,keyscript=decrypt_keyctl"
done > /mnt/etc/crypttab

# Backup the LUKS headers onto /boot
mkdir -p /mnt/boot/luks/
for disk in "${DISKS[@]}"; do
    dev="/dev/${disk}3"
    cryptsetup luksHeaderBackup ${dev} --header-backup-file /mnt/boot/luks/${disk}3-headers.bin
done

echo REMAKE_INITRD=yes > /mnt/etc/dkms/zfs.conf

cat <<EOF > /mnt/etc/default/grub.d/zfs.cfg
GRUB_CMDLINE_LINUX="root=ZFS=rpool/ROOT/debian"
EOF

chroot /mnt update-grub

chroot /mnt update-initramfs -c -k all

zpool export -a
