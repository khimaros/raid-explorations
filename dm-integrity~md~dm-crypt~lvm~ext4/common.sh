RAID_PACKAGES=(dosfstools cryptsetup mdadm lvm2)

DISKS=($(eval echo "$DISKS_GLOB"))

DISKS_DEVICES=($(eval echo "/dev/${DISKS_GLOB}"))

INTEGRITY_DEVICES=($(eval echo "/dev/mapper/${DISKS_GLOB}${DISKS_PART_PREFIX}3_int"))
