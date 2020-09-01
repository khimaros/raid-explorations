#!/bin/bash

set -ex

. default/config.sh

apt install -y debootstrap

debootstrap buster /mnt/

mount --rbind /dev /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /run /mnt/run

mount ${DISKS_DEVICES}2 /mnt/boot

[[ -f default/apt.sh ]] && cp default/apt.sh /mnt/apt.sh

cp default/config.sh /mnt/config.sh

cp chroot.sh /mnt/chroot.sh

chmod +x /mnt/chroot.sh

chroot /mnt /chroot.sh

rm /mnt/config.sh
rm /mnt/chroot.sh
rm -f /mnt/apt.sh
