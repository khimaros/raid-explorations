RAID_PACKAGES=(dosfstools cryptsetup mdadm lvm2)

CRYPT_NAMES=($(eval echo "${DISKS_GLOB}${DISKS_PART_PREFIX}3_crypt"))

CRYPT_DEVICES=($(eval echo "/dev/mapper/${DISKS_GLOB}${DISKS_PART_PREFIX}3_crypt"))

BOOT_DEVICES=($(eval echo "/dev/${DISKS_GLOB}${DISKS_PART_PREFIX}2"))

BOOT_MD_NAME=boot

ROOT_MD_NAME=root

BOOT_MD_DEVICE=/dev/md/${BOOT_MD_NAME}

ROOT_MD_DEVICE=/dev/md/${ROOT_MD_NAME}

if [[ -n "$REPLACE_DISKS_GLOB" ]]; then
    REPLACE_CRYPT_DEVICES=($(eval echo "/dev/mapper/${REPLACE_DISKS_GLOB}${DISKS_PART_PREFIX}3_crypt"))
    REPLACE_BOOT_DEVICES=($(eval echo "/dev/${REPLACE_DISKS_GLOB}${DISKS_PART_PREFIX}2"))
fi
