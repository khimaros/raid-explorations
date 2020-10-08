#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

umount /mnt/run || true
umount /mnt/sys || true
umount /mnt/proc || true
umount /mnt/dev || true

umount /mnt/boot || true

./${RAID_EXPLORATION}/umount.sh || true

umount /mnt || true
