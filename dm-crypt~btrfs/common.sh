RAID_PACKAGES=(cryptsetup btrfs-progs)

DISKS=($(eval echo "$DISKS_GLOB"))

DISKS_DEVICES=($(eval echo "/dev/${DISKS_GLOB}"))

CRYPT_NAMES=($(eval echo "${DISKS_GLOB}${DISKS_PART_PREFIX}3_crypt"))

CRYPT_DEVICES=($(eval echo "/dev/mapper/${DISKS_GLOB}${DISKS_PART_PREFIX}3_crypt"))
