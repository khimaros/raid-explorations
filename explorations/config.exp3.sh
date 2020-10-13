# debian release to bootstrap
DEBIAN_RELEASE="buster"

# enable debian backports
#DEBIAN_BACKPORTS="yes"

# utility packages unrelated to raid
EXTRA_PACKAGES=(vim git screen)

# device files to use in raid array
DISKS_GLOB="sd{a,b}"

# for nvme drives this is usually "p"
DISKS_PART_PREFIX=""

# extra args to pass to luksFormat
CRYPTSETUP_OPTS=(-c aes-xts-plain64 -s 512 -h sha256)

# enable uefi boot
#BOOT_MODE="efi"

# raid stack and filesystem combination
RAID_EXPLORATION="dm-crypt~btrfs"

# raid level to use for array
#   zfs: raidz1, raidz2, raidz3
#   btrfs: raid1, raid1c3, raid5, raid6, raid10
#   md: 0, 1, 5, 6, 10
RAID_LEVEL="raid1"

# raid level to use for metadata
# defaults to $RAID_LEVEL
#   btrfs: raid1, raid1c3, raid5, raid6, raid10
RAID_METADATA_LEVEL="raid1"
