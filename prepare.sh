#!/bin/bash

set -ex

. ./config.sh
. ./options.sh
. ./${RAID_EXPLORATION}/common.sh

echo "AUTO -all" >> /etc/mdadm/mdadm.conf

grep "^md" /proc/mdstat | awk '{ print $1 }' | while read md; do
    mdadm --stop /dev/$md
done
