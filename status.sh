#!/bin/bash

set -e

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

mdadm --detail /dev/md0

if [[ -e ./${RAID_EXPLORATION}/status.sh ]]; then
    ./${RAID_EXPLORATION}/status.sh
fi
