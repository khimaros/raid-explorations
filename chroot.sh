#!/bin/bash

set -ex

. /config.sh
. /common.sh

[[ -f /apt.sh ]] && /apt.sh

passwd

export LANG=C.UTF-8

apt update

apt install -y "${RAID_PACKAGES[@]}"

apt install -y "${EXTRA_PACKAGES[@]}"

DEBIAN_FRONTEND=noninteractive apt install -y locales console-setup

#dpkg-reconfigure locales
#dpkg-reconfigure keyboard-configuration
#dpkg-reconfigure tzdata

apt install -y linux-image-amd64 grub-pc

update-initramfs -c -k all

apt purge -y os-prober

apt install grub-pc

cat <<EOF > /etc/network/interfaces.d/ens3
auto ens3
iface ens3 inet dhcp
EOF

egrep "^.*? (/boot|/boot/efi|/) " /proc/self/mounts > /etc/fstab

[[ -f /after.sh ]] && /after.sh

apt full-upgrade --autoremove --purge

tasksel install standard
