RAID_PACKAGES=(cryptsetup btrfs-progs)

CRYPT_NAMES=($(eval echo "${DISKS_GLOB}${DISKS_PART_PREFIX}3_crypt"))

CRYPT_DEVICES=($(eval echo "/dev/mapper/${DISKS_GLOB}${DISKS_PART_PREFIX}3_crypt"))

if [[ -n "$REPLACE_DISKS_GLOB" ]]; then
    REPLACE_CRYPT_DEVICES=($(eval echo "/dev/mapper/${REPLACE_DISKS_GLOB}${DISKS_PART_PREFIX}3_crypt"))

    #REPLACE_BOOT_DEVICES=($(eval echo "/dev/${REPLACE_DISKS_GLOB}${DISKS_PART_PREFIX}2"))
fi
