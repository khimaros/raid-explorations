#!/bin/bash

set -ex

cat <<EOF > /etc/apt/sources.list.d/backports.list
deb http://deb.debian.org/debian/ ${DEBIAN_RELEASE}-backports main contrib
EOF

cat <<EOF > /etc/apt/preferences.d/zfs
Package: libnvpair1linux libuutil1linux libzfs2linux libzfslinux-dev libzpool2linux python3-pyzfs pyzfs-doc spl spl-dkms zfs-dkms zfs-dracut zfs-initramfs zfs-test zfsutils-linux zfsutils-linux-dev zfs-zed
Pin: release n=${DEBIAN_RELEASE}-backports
Pin-Priority: 990
EOF

apt update
