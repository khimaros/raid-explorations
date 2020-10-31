#!/bin/bash

set -ex

. /config.sh
. /common.sh

export LANG=C.UTF-8

passwd

sed -i 's/ main/ main contrib/g' /etc/apt/sources.list

[[ -z "${DEBIAN_BACKPORTS}" ]] || cat <<EOF > /etc/apt/sources.list.d/backports.list
deb http://deb.debian.org/debian/ ${DEBIAN_RELEASE}-backports main contrib
EOF

if [[ -f /apt.sh ]]; then
    /apt.sh
fi

apt update

apt install -y "${RAID_PACKAGES[@]}"

apt install -y "${EXTRA_PACKAGES[@]}"

DEBIAN_FRONTEND=noninteractive apt install -y locales

#apt install -y console-setup

#dpkg-reconfigure locales
#dpkg-reconfigure keyboard-configuration
#dpkg-reconfigure tzdata

apt install -y linux-image-amd64

ETHDEV=$(ip addr show | awk '/inet.*brd/{print $NF; exit}')
test -n "$ETHDEV" || ETHDEV=enp0s1
echo -e "\nauto $ETHDEV\niface $ETHDEV inet dhcp\n" >> /etc/network/interfaces.d/$ETHDEV

apt full-upgrade -y --autoremove --purge

tasksel install standard

