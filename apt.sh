#!/bin/bash

set -ex

. ./config.sh
. ./options.sh
. ./${RAID_EXPLORATION}/common.sh

if [[ -f "./${RAID_EXPLORATION}/apt.sh" ]]; then
    ./${RAID_EXPLORATION}/apt.sh
fi

sed -i 's/ main/ main contrib/g' /etc/apt/sources.list

[[ -z "${DEBIAN_BACKPORTS}" ]] || cat <<EOF > /etc/apt/sources.list.d/backports.list
deb http://deb.debian.org/debian/ ${DEBIAN_RELEASE}-backports main contrib
EOF

apt update && apt install -y "${EXTRA_PACKAGES[@]}"

apt install -y mdadm

apt install -y "${RAID_PACKAGES[@]}"

apt install -y gdisk dosfstools
