#!/bin/bash

set -ex

cat <<EOF > /etc/apt/sources.list.d/backports.list
deb http://deb.debian.org/debian/ buster-backports main contrib
EOF

cat <<EOF > /etc/apt/preferences.d/btrfs
Package: linux-image-amd64 btrfs-progs
Pin: release n=buster-backports
Pin-Priority: 990
EOF

apt update
