RAID_PACKAGES=(cryptsetup zfs-dkms zfsutils-linux)

DISKS=($(eval echo "$DISKS_GLOB"))

DISKS_DEVICES=($(eval echo "/dev/${DISKS_GLOB}"))

CRYPT_NAMES=($(eval echo "${DISKS_GLOB}3_crypt"))

CRYPT_DEVICES=($(eval echo "/dev/mapper/${DISKS_GLOB}3_crypt"))
