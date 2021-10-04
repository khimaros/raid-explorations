RAID_PACKAGES=(dosfstools cryptsetup mdadm lvm2)

BOOT_DEVICES=($(eval echo "/dev/${DISKS_GLOB}${DISKS_PART_PREFIX}2"))

REPLACE_BOOT_DEVICES=($(eval echo "/dev/${REPLACE_DISKS_GLOB}${DISKS_PART_PREFIX}2"))

ROOT_DEVICES=($(eval echo "/dev/mapper/${DISKS_GLOB}${DISKS_PART_PREFIX}3_int"))

REPLACE_ROOT_DEVICES=($(eval echo "/dev/mapper/${REPLACE_DISKS_GLOB}${DISKS_PART_PREFIX}3_int"))

BOOT_MD=md1

ROOT_MD=md2
