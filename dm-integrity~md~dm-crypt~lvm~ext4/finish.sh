#!/bin/bash

set -ex

. "$(dirname "$0")/common.sh"

mkdir -p /mnt/etc/udev/rules.d/
mkdir -p /mnt/etc/initramfs-tools/hooks/

uuid=$(blkid -s UUID -o value /dev/md0)
echo "md0_crypt UUID=${uuid} none luks,discard" >> /mnt/etc/crypttab

echo "/dev/vg0/root / ext4 rw,relatime,errors=remount-ro 0 0" >> /etc/fstab

cat <<EOF > /mnt/etc/udev/rules.d/99-integrity.rules
ACTION=="add", SUBSYSTEM=="block", ENV{DEVTYPE}=="partition", ENV{ID_FS_TYPE}=="DM_integrity", RUN+="/sbin/integritysetup open --integrity sha256 \$env{DEVNAME} %k_int"
ACTION=="remove", SUBSYSTEM=="block", ENV{DEVTYPE}=="partition", ENV{ID_FS_TYPE}=="DM_integrity", RUN+="/sbin/integritysetup close %k_int"
EOF

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
copy_exec /sbin/integritysetup /sbin
copy_file text /etc/udev/rules.d/99-integrity.rules
EOF

chmod ug+x /mnt/etc/initramfs-tools/hooks/integrity

chroot /mnt update-initramfs -u -k all
