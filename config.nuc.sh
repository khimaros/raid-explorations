DEBIAN_RELEASE="buster"

EXTRA_PACKAGES=(vim git screen)

DISKS_GLOB="nvme{0,1,2,3}n1"

# for nvme drives this is usually "p"
DISKS_PART_PREFIX="p"

# enable uefi boot
BOOT_MODE="efi"

# raid level to use for array
#   zfs: raidz1, raidz2, raidz3
#   btrfs: raid1, raid1c3, raid5, raid6, raid10
#   md: 0, 1, 5, 6, 10
RAID_LEVEL="raidz2"

# raid level to use for metadata
# defaults to $RAID_LEVEL
#   btrfs: raid1, raid1c3, raid5, raid6, raid10
#RAID_METADATA_LEVEL="raid1c3"
