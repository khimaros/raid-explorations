#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"

[[ -z "${DEBIAN_BACKPORTS}" ]] || cat <<EOF > /etc/apt/preferences.d/backports
Package: libnvpair1linux libuutil1linux libzfs2linux libzfslinux-dev libzpool2linux python3-pyzfs pyzfs-doc spl spl-dkms zfs-dkms zfs-dracut zfs-initramfs zfs-test zfsutils-linux zfsutils-linux-dev zfs-zed
Pin: release n=${DEBIAN_RELEASE}-backports
Pin-Priority: 990
EOF
