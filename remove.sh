#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

# IMPORTANT: Update DISKS_GLOB in config.sh before running.

for disk in "${DISKS_DEVICES[@]}"; do
    mdadm --fail /dev/md0 ${disk}1 || true
    mdadm --remove /dev/md0 ${disk}1 || true
done

if [[ -e ./${RAID_EXPLORATION}/remove.sh ]]; then
    ./${RAID_EXPLORATION}/remove.sh
fi
