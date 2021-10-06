#!/bin/bash

set -ex

. ./config.sh
. ./${RAID_EXPLORATION}/common.sh

sed -i 's/ main/ main contrib/g' /etc/apt/sources.list

[[ -z "${DEBIAN_BACKPORTS}" ]] || cat <<EOF > /etc/apt/sources.list.d/backports.list
deb http://deb.debian.org/debian/ ${DEBIAN_RELEASE}-backports main contrib
EOF

apt update && apt install -y "${EXTRA_PACKAGES[@]}"

apt install -y mdadm

echo "AUTO -all" >> /etc/mdadm/mdadm.conf

grep "^md" /proc/mdstat | awk '{ print $1 }' | while read md; do
    mdadm --stop /dev/$md
done

./partition.sh

if [[ "$BOOT_MODE" = "efi" ]]; then
    mdadm --zero-superblock --metadata=1.0 "${EFI_DEVICES[@]}" || true

    mdadm --create --metadata=1.0 --name=efi /dev/md/efi --level=1 --raid-devices=4 --bitmap=internal "${EFI_DEVICES[@]}"

    wipefs -a /dev/md/efi

    mkfs.msdos -F 32 -s 1 -n EFI /dev/md/efi
fi

apt install -y "${RAID_PACKAGES[@]}"
