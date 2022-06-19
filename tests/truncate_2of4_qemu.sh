#!/bin/bash
#
# NOTE: This must be run on the host machine.

set -x

DISK_IMAGES=(
    /var/lib/libvirt/images/raidexp-disk1.img
    /var/lib/libvirt/images/raidexp-disk3.img
)

for disk in "${DISK_IMAGES[@]}"; do
    sudo truncate -s 0 $disk
    sudo truncate -s 5368709120 $disk
done
