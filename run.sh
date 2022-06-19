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

if [[ -f "./${RAID_EXPLORATION}/apt.sh" ]]; then
    ./${RAID_EXPLORATION}/apt.sh
fi

./apt.sh

./prepare.sh

./partition.sh

if [[ -f "./${RAID_EXPLORATION}/map.sh" ]]; then
    ./${RAID_EXPLORATION}/map.sh
fi

./format.sh

./install.sh

cp -a "$(realpath .)" /mnt/root/

./bootloader.sh

./${RAID_EXPLORATION}/finish.sh

./cleanup.sh

./close.sh

echo "Debian installation completed successfully! Reboot required."
