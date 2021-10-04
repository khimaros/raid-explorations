#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

for disk in "${REPLACE_DISKS_DEVICES[@]}"; do
    mdadm --fail /dev/md0 ${disk}1 || true
    mdadm --remove /dev/md0 ${disk}1 || true
done

if [[ -e ./${RAID_EXPLORATION}/remove.sh ]]; then
    ./${RAID_EXPLORATION}/remove.sh
fi
