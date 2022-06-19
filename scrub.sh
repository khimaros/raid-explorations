#!/bin/bash

set -ex

. ./config.sh
. ./options.sh
. ./${RAID_EXPLORATION}/common.sh

mdadm --action=check ${BOOT_MD_DEVICE}
mdadm --wait ${BOOT_MD_DEVICE}

if [[ "${BOOT_MODE}" = "efi" ]]; then
    mdadm --action=check ${EFI_MD_DEVICE}
    mdadm --wait ${EFI_MD_DEVICE}
fi

./${RAID_EXPLORATION}/scrub.sh

./status.sh
