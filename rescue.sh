#!/bin/bash

set -e

read -s -p "Encryption password: " CRYPT_PASSWORD

export CRYPT_PASSWORD

export RESCUE_MODE=1

set -x

. ./config.sh
. ./options.sh
. ./${RAID_EXPLORATION}/common.sh

apt update && apt install -y "${EXTRA_PACKAGES[@]}"

apt install -y "${RAID_PACKAGES[@]}"

./${RAID_EXPLORATION}/mount.sh

./bind.sh
