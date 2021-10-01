#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

apt install -y debootstrap

debootstrap ${DEBIAN_RELEASE} /mnt/

./bind.sh

if [[ -f "./${RAID_EXPLORATION}/apt.sh" ]]; then
    cp "./${RAID_EXPLORATION}/apt.sh" /mnt/apt.sh
fi

cp config.sh /mnt/config.sh
cp "./${RAID_EXPLORATION}/common.sh" /mnt/common.sh
cp chroot.sh /mnt/chroot.sh

chmod +x /mnt/chroot.sh

chroot /mnt /chroot.sh

./bootloader.sh

uuid=$(blkid -s PARTUUID -o value ${DISKS_DEVICES}${DISKS_PART_PREFIX}1)
echo "PARTUUID=${uuid} /boot/efi vfat rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro 0 0" >> /mnt/etc/fstab
