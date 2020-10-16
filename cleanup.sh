#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

rm -f /mnt/chroot.sh /mnt/config.sh /mnt/common.sh /mnt/apt.sh

umount /mnt/run || true
umount /mnt/sys || true
umount /mnt/proc || true
umount /mnt/dev || true

umount /mnt/boot/efi || true
umount /mnt/boot || true

./${RAID_EXPLORATION}/umount.sh || true

umount /mnt || true
