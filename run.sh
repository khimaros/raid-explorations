#!/bin/bash

set -ex

. config.sh

[[ -f "./${RAID_EXPLORATION}/apt.sh" ]] && ./${RAID_EXPLORATION}/apt.sh

./prepare.sh

./${RAID_EXPLORATION}/format.sh

./install.sh

./${RAID_EXPLORATION}/finish.sh
