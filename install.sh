#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

apt install -y debootstrap

debootstrap ${DEBIAN_RELEASE} /mnt/

mount --rbind /dev /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /run /mnt/run

mkdir -p /mnt/boot
mount ${DISKS_DEVICES}${DISKS_PART_PREFIX}2 /mnt/boot

[[ -f "./${RAID_EXPLORATION}/apt.sh" ]] && cp "./${RAID_EXPLORATION}/apt.sh" /mnt/apt.sh

cp config.sh /mnt/config.sh
cp "./${RAID_EXPLORATION}/common.sh" /mnt/common.sh
cp chroot.sh /mnt/chroot.sh

chmod +x /mnt/chroot.sh

chroot /mnt /chroot.sh

if [[ "$BOOT_MODE" = "efi" ]]; then
    mkdir -p /mnt/boot/efi

    #for disk in "${DISKS_DEVICES[@]}"; do
    #    mount ${disk}${DISKS_PART_PREFIX}1 /mnt/boot/efi
    #    chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --no-nvram --recheck --no-floppy
    #    umount /mnt/boot/efi
    #done

    mount ${DISKS_DEVICES}${DISKS_PART_PREFIX}1 /mnt/boot/efi
    chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --no-nvram --recheck --no-floppy
    umount /mnt/boot/efi
fi

uuid=$(blkid -s PARTUUID -o value ${DISKS_DEVICES}${DISKS_PART_PREFIX}2)
echo "PARTUUID=${uuid} /boot ext4 rw,relatime 0 0" > /mnt/etc/fstab
uuid=$(blkid -s PARTUUID -o value ${DISKS_DEVICES}${DISKS_PART_PREFIX}1)
echo "PARTUUID=${uuid} /boot/efi vfat rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro 0 0" >> /mnt/etc/fstab

rm -f /mnt/config.sh /mnt/common.sh /mnt/chroot.sh /mnt/apt.sh
