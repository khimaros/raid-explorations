#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

apt install -y debootstrap

debootstrap ${DEBIAN_RELEASE} /mnt/

if [[ -f "./${RAID_EXPLORATION}/apt.sh" ]]; then
    cp "./${RAID_EXPLORATION}/apt.sh" /mnt/apt.sh
fi

cp config.sh /mnt/config.sh
cp "./${RAID_EXPLORATION}/common.sh" /mnt/common.sh
cp chroot.sh /mnt/chroot.sh

chmod +x /mnt/chroot.sh

./bind.sh

chroot /mnt /chroot.sh

./bootloader.sh

cp -a "$(realpath .)" /mnt/root/
