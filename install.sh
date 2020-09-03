#!/bin/bash

set -ex

. config.sh
. default/common.sh

apt install -y debootstrap

debootstrap buster /mnt/

mount --rbind /dev /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /run /mnt/run

mkdir -p /mnt/boot
mount ${DISKS_DEVICES}${DISKS_PART_PREFIX}2 /mnt/boot

[[ -f default/apt.sh ]] && cp default/apt.sh /mnt/apt.sh
[[ -f default/after.sh ]] && cp default/after.sh /mnt/after.sh

cp config.sh /mnt/config.sh
cp default/common.sh /mnt/common.sh
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

    mount ${DISK_DEVICES}${DISKS_PART_PREFIX}1 /mnt/boot/efi
    chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --no-nvram --recheck --no-floppy
    umount /mnt/boot/efi
fi

rm /mnt/config.sh
rm /mnt/common.sh
rm /mnt/chroot.sh
rm -f /mnt/apt.sh

