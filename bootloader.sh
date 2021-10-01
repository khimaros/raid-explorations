#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

chroot /mnt apt purge -y os-prober

if [[ "$BOOT_MODE" = "efi" ]]; then
    chroot /mnt apt install -y grub-efi-amd64 shim-signed
else
    chroot /mnt apt install -y grub-pc
fi

if [[ "$BOOT_MODE" = "efi" ]]; then
    chroot /mnt grub-install --target=x86_64-efi \
        --bootloader-id=debian-${DISKS_DEVICES[0]##/dev/} \
				--efi-directory=/boot/efi --no-nvram --recheck --no-floppy
else
    chroot /mnt dpkg-reconfigure grub-pc
    for disk in "${DISK_DEVICES[@]}"; do
        chroot /mnt grub-install ${disk}
    done
fi

chroot /mnt update-initramfs -c -k all

chroot /mnt update-grub

if [[ "$BOOT_MODE" = "efi" ]]; then
    umount /mnt/boot/efi

    #for disk in "${DISKS_DEVICES[@]:1}"; do
    #    mount ${disk}${DISKS_PART_PREFIX}1 /mnt/boot/efi
    #    chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --no-nvram --recheck --no-floppy
    #    umount /mnt/boot/efi
    #done

    for disk in "${DISKS_DEVICES[@]:1}"; do
        dd if=${DISKS_DEVICES[0]}${DISKS_PART_PREFIX}1 of=${disk}${DISKS_PART_PREFIX}1
        chroot /mnt efibootmgr -c -g -d ${disk} -p 1 -L "debian-${disk##/dev/}" -l '\EFI\debian\grubx64.efi'
    done
fi
