#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"

[[ -n "${DEBIAN_BACKPORTS}" ]] && cat <<EOF > /etc/apt/preferences.d/backports
Package: linux-image linux-image-amd64 linux-headers firmware-linux firmware-linux-nonfree
Pin: release n=${DEBIAN_RELEASE}-backports
Pin-Priority: 990
EOF
