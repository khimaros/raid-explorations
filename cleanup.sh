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

mount | tac | awk '/\/mnt/ {print $3}' | \
    xargs -i{} umount -lf {}

./${RAID_EXPLORATION}/close.sh || true
