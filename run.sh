#!/bin/bash

set -ex

. config.sh

if [[ -f "./${RAID_EXPLORATION}/apt.sh" ]]; then
    ./${RAID_EXPLORATION}/apt.sh
fi

./prepare.sh

if [[ -f "./${RAID_EXPLORATION}/map.sh" ]]; then
    ./${RAID_EXPLORATION}/map.sh
fi

./${RAID_EXPLORATION}/format.sh

./install.sh

./${RAID_EXPLORATION}/finish.sh

./cleanup.sh

echo "Debian installation completed successfully! Reboot required."
