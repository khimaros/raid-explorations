#!/bin/bash

set -ex

. ./config.sh
. ./options.sh
. ./${RAID_EXPLORATION}/common.sh

umount /mnt/boot/efi || true

umount /mnt/boot || true

./${RAID_EXPLORATION}/close.sh || true
