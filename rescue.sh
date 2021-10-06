#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

apt update && apt install -y "${EXTRA_PACKAGES[@]}"

apt install -y "${RAID_PACKAGES[@]}"

./${RAID_EXPLORATION}/mount.sh

mount /dev/md/efi /mnt/boot/efi
