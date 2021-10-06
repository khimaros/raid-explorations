#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

chroot /mnt apt install -y keyutils

# FIXME: discard should be enabled on eg. SSD devices.

for disk in "${DISKS[@]}"; do
    uuid=$(blkid -s UUID -o value /dev/${disk}${DISKS_PART_PREFIX}3)
    echo "${disk}${DISKS_PART_PREFIX}3_crypt UUID=${uuid} none luks,initramfs,keyscript=decrypt_keyctl"
done > /mnt/etc/crypttab

echo "/dev/vg0/root / ext4 rw,relatime,errors=remount-ro 0 0" >> /mnt/etc/fstab

echo "${BOOT_MD_DEVICE} /boot ext4 rw,relatime,errors=remount-ro 0 0" >> /mnt/etc/fstab

mkdir -p /mnt/etc/initramfs-tools/hooks/

cat <<EOF > /mnt/etc/initramfs-tools/hooks/integrity
#!/bin/sh
PREREQ=""
prereqs()
{
    echo "\$PREREQ"
}

case \$1 in
    prereqs)
        prereqs
        exit 0
        ;;
esac

. /usr/share/initramfs-tools/hook-functions

# Begin real processing below this line

force_load dm_integrity
EOF

chmod ug+x /mnt/etc/initramfs-tools/hooks/integrity

chroot /mnt update-grub

chroot /mnt update-initramfs -u -k all
