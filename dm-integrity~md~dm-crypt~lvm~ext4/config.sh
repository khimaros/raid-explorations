DEFAULT_PACKAGES=(screen vim parted dosfstools)

RAID_PACKAGES=(cryptsetup mdadm lvm2)

DISKS_GLOB="nvme{0,1,2,3}n1p"

DISKS=($(eval echo "$DISKS_GLOB"))

DISKS_DEVICES=($(eval echo "/dev/${DISKS_GLOB}"))

INTEGRITY_DEVICES=($(eval echo "/dev/mapper/${DISKS_GLOB}3_int"))

RAID_LEVEL=6
