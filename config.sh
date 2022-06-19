############################
# RAID ARRAY CONFIGURATION #
############################

# debian release to bootstrap
DEBIAN_RELEASE="bullseye"

# enable debian backports
#DEBIAN_BACKPORTS="yes"

# enable uefi boot
BOOT_MODE="efi"

# utility packages unrelated to raid
EXTRA_PACKAGES=(vim git tmux)

# device files to use in raid array
DISKS_GLOB="sd{a,b,c,d}"

# devices to reformat and replace in the array
#REPLACE_DISKS_GLOB="sd{a,c}"

# for nvme drives this is usually "p"
DISKS_PART_PREFIX=""

# extra args to pass to luksFormat
CRYPTSETUP_OPTS=(--cipher=aes-xts-plain64 --key-size=512 --hash=sha256)

# cryptsetup args to enable integrity checking in the dm-crypt layer
# this is typically not needed for btrfs/zfs which have their own csum
#CRYPTSETUP_OPTS=("${CRYPTSETUP_OPTS[@]}" --integrity=hmac-sha256)

# extra args to pass to integritysetup
# for dm-integrity based stacks, this should be enabled
# and CRYPTSETUP_OPTS integrity line should be disabled.
#INTEGRITYSETUP_OPTS=(--integrity=sha1)

# extra args to pass to mdadm when creating boot and efi arrays
MDADM_BOOT_OPTS=(--level=1 --raid-devices=4 --bitmap=internal)

# raid stack and filesystem combination
#   dm-crypt~btrfs
#   dm-crypt~zfs
#   dm-crypt~md~lvm~ext4
#   dm-integrity~md~dm-crypt~lvm~ext4
RAID_EXPLORATION="dm-crypt~btrfs"

# raid level to use for array
#   zfs: raidz1, raidz2, raidz3
#   btrfs: raid0, raid1, raid1c2, raid1c3, raid1c4, raid5, raid6, raid10
#   md: 0, 1, 5, 6, 10
RAID_LEVEL="raid1c3"

# raid level to use for metadata
# defaults to $RAID_LEVEL if undefined
#   btrfs: raid0, raid1, raid1c2, raid1c3, raid1c4, raid5, raid6, raid10
RAID_METADATA_LEVEL="raid1c4"
