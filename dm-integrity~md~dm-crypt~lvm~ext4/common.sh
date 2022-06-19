RAID_PACKAGES=(dosfstools cryptsetup mdadm lvm2)

#BOOT_DEVICES=($(eval echo "/dev/${DISKS_GLOB}${DISKS_PART_PREFIX}2"))

ROOT_DEVICES=($(eval echo "/dev/mapper/${DISKS_GLOB}${DISKS_PART_PREFIX}3_int"))

#BOOT_MD_NAME=boot

ROOT_MD_NAME=root

#BOOT_MD_DEVICE=/dev/md/${BOOT_MD_NAME}

ROOT_MD_DEVICE=/dev/md/${ROOT_MD_NAME}

ROOT_CRYPT_NAME=md_${ROOT_MD_NAME}_crypt

ROOT_CRYPT_DEVICE=/dev/mapper/${ROOT_CRYPT_NAME}

if [[ -n "$REPLACE_DISKS_GLOB" ]]; then
    #REPLACE_BOOT_DEVICES=($(eval echo "/dev/${REPLACE_DISKS_GLOB}${DISKS_PART_PREFIX}2"))

    REPLACE_ROOT_DEVICES=($(eval echo "/dev/mapper/${REPLACE_DISKS_GLOB}${DISKS_PART_PREFIX}3_int"))
fi
