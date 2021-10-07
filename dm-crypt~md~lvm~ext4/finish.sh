#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

chroot /mnt apt install -y keyutils

# FIXME: discard should be enabled on eg. SSD devices.

# Prepare /etc/crypttab
for disk in "${DISKS[@]}"; do
    uuid=$(blkid -s UUID -o value /dev/${disk}${DISKS_PART_PREFIX}3)
    echo "${disk}${DISKS_PART_PREFIX}3_crypt UUID=${uuid} none luks,initramfs,keyscript=decrypt_keyctl"
done > /mnt/etc/crypttab

# Backup the LUKS headers onto /boot
mkdir -p /mnt/boot/luks/
for disk in "${DISKS[@]}"; do
    dev="/dev/${disk}3"
    cryptsetup luksHeaderBackup ${dev} --header-backup-file /mnt/boot/luks/${disk}3-headers.bin
done

# Generate /etc/fstab
echo "/dev/vg0/root / ext4 rw,relatime,errors=remount-ro 0 0" >> /mnt/etc/fstab
echo "${BOOT_MD_DEVICE} /boot ext4 rw,relatime,errors=remount-ro 0 0" >> /mnt/etc/fstab

# Configure the initrd with dm_integrity module.
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

chroot /mnt update-initramfs -c -k all
