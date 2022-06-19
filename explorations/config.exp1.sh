############################
# RAID ARRAY CONFIGURATION #
############################

# debian release to bootstrap
DEBIAN_RELEASE="buster"

# enable debian backports
DEBIAN_BACKPORTS="yes"

# utility packages unrelated to raid
EXTRA_PACKAGES=(vim git screen)

# device files to use in raid array
DISKS_GLOB="sd{a,b,c,d}"

# devices to reformate and replace in the array
#REPLACE_DISKS_GLOB="sd{a,c}"

# for nvme drives this is usually "p"
DISKS_PART_PREFIX=""

# extra args to pass to luksFormat
CRYPTSETUP_OPTS=(--cipher=aes-xts-plain64 --key-size=512 --hash=sha256)

# extra args to pass to integritysetup
INTEGRITYSETUP_OPTS=(--integrity=sha1)

# extra args to pass to mdadm when creating boot and efi arrays
MDADM_BOOT_OPTS=(--metadata=1.0 --level=1 --raid-devices=4 --bitmap=internal)

# enable uefi boot
#BOOT_MODE="efi"

# raid stack and filesystem combination
RAID_EXPLORATION="dm-integrity~md~dm-crypt~lvm~ext4"

# raid level to use for array
#   zfs: raidz1, raidz2, raidz3
#   btrfs: raid1, raid1c3, raid5, raid6, raid10
#   md: 0, 1, 5, 6, 10
RAID_LEVEL="6"

# raid level to use for metadata
# defaults to $RAID_LEVEL
#   btrfs: raid1, raid1c3, raid5, raid6, raid10
#RAID_METADATA_LEVEL=""
