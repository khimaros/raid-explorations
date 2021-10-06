#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

mdadm --action=check /dev/md/efi

mdadm --wait /dev/md/efi

./${RAID_EXPLORATION}/scrub.sh

./status.sh
