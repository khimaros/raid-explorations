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

apt purge -y os-prober

if [[ "$BOOT_MODE" = "efi" ]]; then
    apt install -y grub-efi-amd64 shim-signed
else
    apt install -y grub-pc
fi

apt install -y linux-image-amd64

ETHDEV=$(ip addr show | awk '/inet.*brd/{print $NF; exit}')
test -n "$ETHDEV" || ETHDEV=enp0s1
echo -e "\nauto $ETHDEV\niface $ETHDEV inet dhcp\n" >> /etc/network/interfaces.d/$ETHDEV

egrep "^.*? (/boot|/boot/efi|/) " /proc/self/mounts > /etc/fstab

update-initramfs -c -k all

[[ -f /after.sh ]] && /after.sh

apt full-upgrade --autoremove --purge

tasksel install standard
