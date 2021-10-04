#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

mdadm --action=check /dev/md0

mdadm --wait /dev/md0

./${RAID_EXPLORATION}/scrub.sh

./status.sh
