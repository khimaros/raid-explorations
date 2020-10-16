#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

./prepare.sh

./${RAID_EXPLORATION}/format.sh

./bind.sh

./bootloader.sh

uuid=$(blkid -s PARTUUID -o value ${DISKS_DEVICES}${DISKS_PART_PREFIX}2)
sed -i "s|PARTUUID=(.*?) /boot |PARTUUID=${uuid} /boot |g" /mnt/etc/fstab
uuid=$(blkid -s PARTUUID -o value ${DISKS_DEVICES}${DISKS_PART_PREFIX}1)
sed -i "s|PARTUUID=(.*?) /boot/efi |PARTUUID=${uuid} /boot/efi |g" /mnt/etc/fstab

