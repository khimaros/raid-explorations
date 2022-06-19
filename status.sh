#!/bin/bash

set -e

. ./config.sh
. ./options.sh
. ./${RAID_EXPLORATION}/common.sh

mdadm --detail ${BOOT_MD_DEVICE}
echo

if [[ "${BOOT_MODE}" = "efi" ]]; then
    mdadm --detail ${EFI_MD_DEVICE}
    echo
fi

if [[ -e ./${RAID_EXPLORATION}/status.sh ]]; then
    ./${RAID_EXPLORATION}/status.sh
fi
