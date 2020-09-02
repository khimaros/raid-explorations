EXTRA_PACKAGES=(vim git screen)

DISKS_GLOB="sd{a,b,c,d}"

# raid level to use for array
#   zfs: raidz1, raidz2, raidz3
#   btrfs: raid1, raid1c3, raid5, raid6, raid10
#   md: 0, 1, 5, 6, 10
RAID_LEVEL="raidz2"
