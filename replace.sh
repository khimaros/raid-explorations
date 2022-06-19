#!/bin/bash

set -e

read -s -p "Encryption password: " CRYPT_PASSWORD
echo
read -s -p "Encryption password (verify): " CRYPT_PASSWORD_VERIFY
echo

if [[ "$CRYPT_PASSWORD" != "$CRYPT_PASSWORD_VERIFY" ]]; then
    echo "Passwords did not match. Exiting!"
    exit 1
fi

export CRYPT_PASSWORD

set -x

. ./config.sh
. ./options.sh
. ./${RAID_EXPLORATION}/common.sh

if [[ -z "$REPLACE_DISKS_GLOB" ]]; then
    echo "[!!] you MUST specify REPLACE_DISKS_GLOB before execution"
    exit 1
fi

export REPLACE_MODE=1

apt install -y gdisk

./remove.sh

./partition.sh

for dev in "${REPLACE_BOOT_DEVICES[@]}"; do
    mdadm --add ${BOOT_MD_DEVICE} "$dev"
done

if [[ "$BOOT_MODE" = "efi" ]]; then
    for dev in "${REPLACE_EFI_DEVICES[@]}"; do
        mdadm --add ${EFI_MD_DEVICE} "$dev"
    done
fi

./${RAID_EXPLORATION}/map.sh

./${RAID_EXPLORATION}/replace.sh

# FIXME: deduplicate this with ./bootloader.sh
# and chroot /mnt when run from a live CD.

for ((i=${#REPLACE_DISKS_DEVICES[@]}-1; i>=0; i--)); do
    disk="${REPLACE_DISKS_DEVICES[$i]}"
    if [[ "$BOOT_MODE" = "efi" ]]; then
        label="debian-${disk##/dev/}"
        efibootmgr -c -g -d ${disk} -p 1 -L "$label" -l '\EFI\debian\grubx64.efi'
    else
        grub-install --force --recheck ${disk}
    fi
done

./status.sh
