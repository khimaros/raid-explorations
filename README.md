# raid explorations

This repository contains explorations in modern forms of full-disk
encrypted RAID on Debian GNU/Linux. Based on my observations in these
experiments, **I recommend dm-crypt based ZFS raidz2.**

Of the configurations explored, ZFS degraded the most gracefully, even
when corruption was well beyond the parameters defined by the RAID
level under test. ZFS clearly identifies corrupt files in `zpool status`.

Even with megabytes of randomized corruption, the ZFS pool was always
able to be assembled and scrubbed, and there were no kernel panics or
other showstopping issues except where the operating system could no
longer carry on due to missing critical files.

Runner-ups include btrfs in raid1c3/raid1c3 configuration and stacked
dm-integrity + md + dm-crypt + lvm + ext4 in a raid6 configuration on
Linux >= 5.4-rc1. These are reliable options but the management and
scrub interfaces are not as ergonomic as ZFS.

Further, based on these observations, **I STRONGLY recommend against
using dm-integrity in combination with md on Linux <5.4-rc1 for
any important data**; as few as 100 bytes of corruption can render
a disk completely unusable.

Available explorations are as follows:

 id                                  | kernel | stack            | level           | notes
 ----------------------------------- | ------ | ---------------- | --------------- | -----
 [exp0](explorations/config.exp0.sh) | 4.19   | md-stacked\*     | 6               | strongly discouraged
 [exp1](explorations/config.exp1.sh) | 5.7    | md-stacked\*     | 6               | okay
 [exp2](explorations/config.exp2.sh) | 5.10   | md-stacked\*     | 6               | okay
 [exp3](explorations/config.exp3.sh) | 4.19   | dm-crypt + btrfs | raid1/raid1     |
 [exp4](explorations/config.exp4.sh) | 5.8    | dm-crypt + btrfs | raid6/raid6     |
 [exp5](explorations/config.exp5.sh) | 5.8    | dm-crypt + btrfs | raid6/raid1c3   |
 [exp6](explorations/config.exp6.sh) | 5.8    | dm-crypt + btrfs | raid1c3/raid1c3 |
 [exp7](explorations/config.exp7.sh) | 4.19   | dm-crypt + zfs   | raidz2          |
 [exp8](explorations/config.exp8.sh) | 5.8    | dm-crypt + zfs   | raidz2          |
 [exp9](explorations/config.exp9.sh) | 5.10   | md-combined\*\*  | 6               |

\* dm-integrity + md + dm-crypt + lvm + ext4
\*\* dm-crypt (integrity) + md + lvm + ext4

## caveats

Corruption of metadata (generally at the start of the disk) on
dm based devices generally renders the device unusable. ZFS and
btrfs distribute metadata across the entire device. However, if
backed by dm-crypt, these protections are void. It's a good idea to
backup device metadata, particularly with dm-crypt.

ZFS and btrfs provide better tooling for detection of corrupted files, and
scans take a small fraction of the time required for a full md scan.
Corruption is only detected on dm-integrity based systems by inspecting
`dmesg` output after a read attempt is made (eg. during a full scan).

Upon disk failure, btrfs volumes must be manually mounted in degraded
mode in order to boot the system.

## setup

**WARNING**: following these instructions by default will destroy
all data on `/dev/sd{a,b,c,d}`. It is only recommended to run these
scripts in a VM or on a machine with no important data.

1. Boot a "standard" Debian LiveCD. [stable](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/), [testing](https://cdimage.debian.org/cdimage/weekly-live-builds/amd64/iso-hybrid/)

1. Fetch this repository:

```
$ sudo -i

# apt update && apt install -y vim git

# git clone https://github.com/khimaros/raid-explorations

# cd raid-explorations
```

1. Edit `config.sh` to choose the correct drives, Debian release, and RAID level.

1. Start the installation:

```
# ./run.sh
```

1. Reboot into the new installation.

## overview

### comparison

 requirement          | md\* raid6 | dm-crypt + btrfs raid1c3/raid1c3 | dm-crypt + zfs raidz2
 -------------------- | ---------- | -------------------------------- | ---------------------
 space efficiency     | C          | B                                | A
 performance          | B          | D                                | A
 remote unlock        | A          | A                                | A
 full disk encryption | A          | A                                | A
 resilience           | A          | A                                | A
 recovery             | A          | C                                | B
 system integration   | A          | B                                | D
 predictability       | A          | B                                | B

### resilience

 id                                  | kernel | stack            | level           | 1MB @ 2/4  | 1KB @ 4/4 | 1MB @ 1/2
 ----------------------------------- | ------ | ---------------- | --------------- | ---------- | --------- | ---------
 [exp0](explorations/config.exp0.sh) | 4.19   | md-stacked       | 6               | FAIL\*     | N/A       | N/A
 [exp1](explorations/config.exp1.sh) | 5.7    | md-stacked       | 6               | OKAY       | OKAY      | N/A
 [exp2](explorations/config.exp2.sh) | 5.8    | md-stacked       | 6               | OKAY       | OKAY      | N/A
 [exp3](explorations/config.exp3.sh) | 4.19   | dm-crypt + btrfs | raid1/raid1     | N/A        | N/A       | OKAY
 [exp4](explorations/config.exp4.sh) | 5.8    | dm-crypt + btrfs | raid6/raid6     | FAIL       | N/A       | N/A
 [exp5](explorations/config.exp5.sh) | 5.8    | dm-crypt + btrfs | raid6/raid1c3   | FAIL       | N/A       | N/A
 [exp6](explorations/config.exp6.sh) | 5.8    | dm-crypt + btrfs | raid1c3/raid1c3 | OKAY       | OKAY      | N/A
 [exp7](explorations/config.exp7.sh) | 4.19   | dm-crypt + zfs   | raidz2          | OKAY       | OKAY      | N/A
 [exp8](explorations/config.exp8.sh) | 5.8    | dm-crypt + zfs   | raidz2          | ?          | ?         | N/A

\* fails with as few as 100 bytes of corruption

### performance

lower is better. see `tests/benchmark.sh`.

 id                                  | kernel | stack            | level           | rndwr  | seqwr
 ----------------------------------- | ------ | ---------------- | --------------- | ------ | -----
 [exp8](explorations/config.exp8.sh) | 5.10   | dm-crypt + zfs   | raidz2          | 12.21s | 2.89s
 [exp9](explorations/config.exp9.sh) | 5.10   | md-combined      | 6               | 15.03s |
 [exp2](explorations/config.exp2.sh) | 5.10   | md-stacked       | 6               | 18.97s | 7.45s
 [exp6](explorations/config.exp6.sh) | 5.10   | dm-crypt + btrfs | raid1c3/raid1c3 | 29.79s | 15.3s

## details

### common (md)

if the md table is corrupted on an md array, as is the case when
the entire drive is truncated, you will be dropped to the systemd
recovery shell after a ~45s pause.

you will need to take manual steps to correct:

```
# mdadm --run /dev/md/boot
```

the usual `/dev/md/<name>` devices may not be created until the
array is started manually.

```
# mdadm --run /dev/md*
```

if the array is used in /etc/fstab it is often also necessary
to mount it before continuing:

```
# mount /dev/md/boot /boot
```

ensure that `/proc/mdstat` does not show `auto-read-only` for
any of the arrays and then reboot.

### common (dm-crypt)

if crypt headers are corrupted, cryptsetup will fail many times in a row
as if you typed the password incorrectly.

you'll eventually be dropped to initramfs.

you may need to manually decrypt the healthy drives:

```
(initramfs) cryptsetup luksOpen /dev/sdb3 sdb3_crypt
(initramfs) cryptsetup luksOpen /dev/sdd3 sdd3_crypt
```

### common (btrfs)

if drives are missing in a btrfs multi-disk array, you will
be dropped to initramfs.

you must manually mount the root filesystem with one of the healthy drives:

```
(initramfs) mount -o degraded /dev/mapper/sdb3_crypt /root
```

Ctrl+D to continue booting.

### exp0: linux <5.4-rc1 + dm-integrity + md considered harmful

This outcome has been verified with Linux kernel 4.19 and should affect any
kernel which doesn't include [this EILSEQ patch](https://github.com/torvalds/linux/commit/b76b4715eba0d0ed574f58918b29c1b2f0fa37a8).

tl;dr, on a system with four 10GiB drives in a RAID-5 configuration using the
setup described above, **200 bytes of randomly distributed corruption across
two drives (in non-overlapping stripes) could result in unrecoverable failure
of the entire array**.

To break the integrity device, write 100 random bytes to random
locations on `/dev/sda3`:

```
# ./random_write.py /dev/sda3 100
[*] changing 0xb3 to 0xc1 on /dev/sda3 at byte 78312109 (1 / 100)
[*] changing 0x10 to 0x8d on /dev/sda3 at byte 51332109 (2 / 100)
[*] changing 0x1e to 0xcb on /dev/sda3 at byte 133178139 (3 / 100)
... elided ...

# reboot
```

Boot time assembly will fail and after some timeout you will
reach initramfs. The automated assembly is not usable, so reassemble:

```
(initramfs) mdadm --stop /dev/md2
mdadm: stopped /dev/md2
(initramfs) mdadm --assemble /dev/md2
mdadm: /dev/md2 has been started with 3 drives (out of 4).
```

At this point, you can resume boot by pressing Ctrl+D.

Now try to add the drive back to the array:

```
# mdadm --manage /dev/md2 --add /dev/mapper/sda3_int
[ ... ] Buffer I/O error on dev dm-3, logical block 2324464, async page read
[ ... ] Buffer I/O error on dev dm-3, logical block 2324493, async page read
[ ... ] Buffer I/O error on dev dm-3, logical block 2324494, async page read
[ ... ] Buffer I/O error on dev dm-3, logical block 2324494, async page read
[ ... ] Buffer I/O error on dev dm-3, logical block 0, async page read
[ ... ] Buffer I/O error on dev dm-3, logical block 0, async page read
mdadm: Failed to write metadata to /dev/mapper/sda3_int
# mdadm --examine /dev/mapper/sda3_int
mdadm: No md superblock detected on /dev/mapper/sda3_int.
```

In these cases, even mapping the device with
`integritysetup --integrity-no-journal` or `--integrity-recovery-mode`
does not convince md to accept the device back into the pool:

```
# integritysetup close sda3_int
# integritysetup open --integrity sha256 /dev/sda3 sda3_int
[ ... ] device-mapper: integrity: Error on journal commit id: -5
[ ... ] Buffer I/O error on dev dm-3, logical block 2324464, async page read
# integritysetup close sda3_int
# integritysetup open --integrity sha256 -D -R /dev/sda3 sda3_int
# mdadm --manage /dev/md2 --add /dev/mapper/sda3_int
[ ... ] Buffer I/O error on dev dm-3, logical block 1, async page write
```

**Observation**: logical block `2324464` is always referenced in these errors
despite the randomness employed in the disk corruption.

It may be possible to avoid the dm-integrity read errors by running
`integritysetup --integrity-recalculate` but, if successful, bitrot
is likely to result. this process provides no feedback and is very slow.

The only way I've found to recover a disk is to completely wipe the integrity
device and add it back to the array:

```
# integritysetup close sda3_int
# integritysetup format --integrity sha256 /dev/sda3
Formatted with tag size 4, internal integrity sha256.
Wiping device to initialize integrity checksum.
# integritysetup open --integrity sha256 /dev/sda3 sda3_int
# mdadm --manage /dev/md2 --add /dev/mapper/sda3_int
mdadm: added /dev/mapper/sda3_int
```

I've found that as few as 100 random byte manipulations of an underlying
10GiB block device (avoiding the first 20MiB and last 16MiB of
the partition to avoid metadata) can result in an unrecoverable error
on the dm-integrity device.

In summary, dm-integrity could drastically increase the likelihood of a full
array failure. The risk of this compared with silent bit rot seems to
be significant. The cure may be worse than the poison.

### exp0: linux 4.19 + dm-integrity + md + dm-crypt + lvm + ext4: 1KB corruption on 4/4 raid6 disks

**WARNING**: see warning above about the real world reliability
of devices in this configuration.

if you repair checksums on a dm-integrity device **before stopping the md
array**, the array is actually quite resilient to corruption even when
the corruption is spread across all disks in the array.

Write 1,000 bytes to random positions on all four drives:

```
# for disk in /dev/sd{a,b,c,d}3; do ./random_write.py $disk 1000; done

# mdadm --action=check /dev/md2

# mdadm --wait /dev/md2

# reboot
```

In most cases, I've found the system is completely usable.

Within these constraints, dm-integrity + md has outperformed every other
RAID configuration on this test, often carrying on with all-disk corruption
levels climbing to 100KB and beyond. However, given the coincidence of power
failure and data loss, this setup is still **strongly not recommended**.

### exp1: linux 5.7 + dm-integrity + md + dm-crypt + lvm + ext4: 1MB corruption on 2/4 raid6 disks

md handles heavy corruption within raid6 parameters without a
sweat and a scrub corrects all errors. no permanent data loss occurs.

Write 1,000,000 bytes to random positions on two drives:

```
# for disk in /dev/sd{a,b}3; do ./random_write.py $disk 1000000; done

# reboot
```

Boot and scrub complete without incident:

```
# mdadm --action=check /dev/md2

# mdadm --wait /dev/md2
```

### exp1: linux 5.7 + dm-integrity + md + dm-crypt + lvm + ext4: 1KB corruption on 4/4 raid6 disks

md survives random corruption even affecting all disks in a
raid6 array. some files become unrecoverable, but the system
often still boots and the array always reassembles and scrubs.

Write 1,000 bytes to random positions on two drives:

```
# for disk in /dev/sd{a,b,c,d}3; do ./random_write.py $disk 1000; done

# reboot
```

depending on which files are corrupted (luck), you may be kicked
to initramfs. array reassembly should still work.

in some cases, boot will hang while trying to mount the filesystem.
in this case you can add `break` to your GRUB command line to enter
the `initramfs` console.

in some cases, it may be preferable to boot into LiveCD and
use the rescue script:

```
# ./rescue.sh

# umount /mnt

# mdadm --action=repair /dev/md2

# fsck.ext4 -y -f -c /dev/vg0/root

# reboot
```

to recover from the initramfs console:

```
(initramfs) cryptsetup luksOpen /dev/md2 md2_crypt

(initramfs) vgchange -a y vg0

(initramfs) mount /dev/mapper/vg0-root /root
```

Press Ctrl+D to resume boot.

### exp1: linux 5.7 + dm-integrity + md + dm-crypt + lvm + ext4: removal of 2/4 raid6 disks

disk removal and spare rebuild is handled without issue.

initial boot will be somewhat slower while drives are missing due
to read timeouts.

if the boot or efi partitions are corrupted, you will be dropped to
the recovery shell. you will need to take manual steps to correct:

```
# mdadm --run /dev/md0
# mdadm --run /dev/md1
# mount /dev/md1 /boot
# mount /dev/md0 /boot/efi
```

ensure that `/proc/mdstat` does not show `auto-read-only` for
any of the arrays and then reboot.

after boot, everything works fine. the drives show as `removed`:

```
# mdadm --detail /dev/md2
```

drives can be re-added to the array:

```
# sgdisk -R /dev/sdc /dev/sda
# sgdisk -R /dev/sdd /dev/sda
# sgdisk -G /dev/sdc
# sgdisk -G /dev/sdd
# efibootmgr / grub-install
# integritysetup ...
# integritysetup open ...
# mdadm --manage /dev/md2 --re-add /dev/dm-2 /dev/dm-3
```

the steps above are automated with `replace.sh`.

### exp3: linux 4.19 + dm-crypt + btrfs: 1MB corruption on 1/2 raid1/raid1 disks

btrfs handles heavy corruption within raid1 parameters without a
sweat and a scrub corrects all errors. no permanent data loss occurs.

Write 1,000,000 bytes to random positions on one drive:

```
# ./random_write.py /dev/sda3 1000000; done

# reboot
```

Boot and scrub complete without incident:

```
# btrfs scrub start -B -d /

# btrfs device stats -z /
```

### exp4: linux 5.8 + dm-crypt + btrfs: 1MB corruption on 2/4 raid6/raid6 disks

btrfs fails catastrophically in this case despite the corruption
being within expected parameters for a raid6 array.

Write 1,000,000 bytes to random positions on two drives:

```
# for disk in /dev/sd{a,c}3; do ./random_write.py $disk 1000000; done

# reboot
Bus Error
```

Here we can see the corruption is already impacting the running system.

Force reboot. Kernel panic.

### exp5: linux 5.8 + dm-crypt + btrfs: 1MB corruption on 2/4 raid6/raid1c3 disks

btrfs has mixed results from moderate corruption within raid6/raid1c3
parameters. the system boots successfully, but scrub produces a handfull
of uncorrectable errors, indicating some permanent data loss.

Write 1,000,000 bytes to random positions on two drives:

```
# for disk in /dev/sd{a,c}3; do ./random_write.py $disk 1000000; done

# reboot
```

Boot and scrub:

```
# btrfs scrub start -B -d /

# btrfs device stats -z /
```

### exp6: linux 5.8 + dm-crypt + btrfs: 1MB corruption on 2/4 raid1c3/raid1c3 disks

btrfs handles heavy corruption within raid1c3 parameters without a
sweat and a scrub corrects all errors. no permanent data loss occurs.

Write 1,000,000 bytes to random positions on two drives:

```
# for disk in /dev/sd{a,c}3; do ./random_write.py $disk 1000000; done

# reboot
```

Boot and scrub complete without incident:

```
# btrfs scrub start -B -d /

# btrfs device stats -z /
```

### exp6: linux 5.8 + dm-crypt + btrfs: 1KB corruption on 4/4 raid1c3/raid1c3 disks

btrfs survives random corruption even affecting all disks in a
raid1c3 array. some files become unrecoverable, but the system
often still boots and the array always reassembles and scrubs.

Write 1,000 bytes to random positions on all four drives:

```
# for disk in /dev/sd{a,b,c,d}3; do ./random_write.py $disk 1000; done

# reboot
```

depending on which files are corrupted (luck), you may be kicked
to initramfs. array reassembly should still work.

### exp7: linux 4.19 + dm-crypt + zfs: 1MB corruption on 2/4 raidz2 disks

zfs handles heavy corruption within raidz2 parameters without a
sweat and a scrub corrects all errors. no permanent data loss occurs.

Write 1,000,000 bytes to random positions on two drives:

```
# for disk in /dev/sd{a,c}3; do ./random_write.py $disk 1000000; done

# reboot
```

Boot and scrub complete without incident:

```
# zpool scrub rpool

# zpool clear rpool
```

one initially surprising outcome is that the scrub surfaces CKSUM errors on
the drives which were untouched. this doesn't seem to have any
real world impact, but was alarming when first noticed.

according to PMT in `#zfsonlinux`:

> checksummed blocks are striped across RAIDZ disks in a vdev, so
> mangling a block is going to raise CKSUM errors from all the
> disks the block is across

### exp7: linux 4.19 + dm-crypt + zfs: 1KB corruption on 4/4 raidz2 disks

zfs survives random corruption even affecting all disks in a
raidz2 array. some files become unrecoverable, but the system
often still boots and the array always reassembles and scrubs.

Write 1,000 bytes to random positions on all four drives:

```
# for disk in /dev/sd{a,b,c,d}3; do ./random_write.py $disk 1000; done

# reboot
```

depending on which files are corrupted (luck), you may be kicked
to initramfs. zpool reassembly should still work.

## references

[Debian Buster Root on ZFS](https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Buster%20Root%20on%20ZFS.html)

[Battle testing ZFS, Btrfs and mdadm+dm-integrity](https://www.unixsheikh.com/articles/battle-testing-zfs-btrfs-and-mdadm-dm.html)

[dm-crypt + dm-integrity + dm-raid = awesome!](https://gist.github.com/MawKKe/caa2bbf7edcc072129d73b61ae7815fb)

[RAID Doesn't work!](https://securitypitfalls.wordpress.com/2018/05/08/raid-doesnt-work/)

[DMIntegrity wiki](https://gitlab.com/cryptsetup/cryptsetup/-/wikis/DMIntegrity)

## appendix

### random\_write

Write random byte content to random positions within a file.

This can be used on block devices, for example, to test RAID or integrity behavior.

#### usage

```
random_write.py <path> <bytes> [start_pad] [end_pad]
```

By default, the first 512MiB and last 128MiB of the file are avoided.

#### examples

Write 1 byte to a random location on /dev/sdb3:

```
# ./random_write.py /dev/sdb3 1
```

Write 1000 bytes to /dev/sdb3:

```
# ./random_write.py /dev/sdb3 1000
```

Write 1000 bytes to /dev/sdb3, avoiding first 1KiB

```
# ./random_write.py /dev/sdb3 1000 1048576
```

## rescue

if you are having difficulty mounting the array, boot into the LiveCD, modify
`config.sh` to match installation time, and run `./rescue.sh`.

## replacing devices

if you need to replace disks in the array, you can add them back to the array
by adding **only** the spare drives to `REPLACE_DISKS_GLOB` and running:

```
./replace.sh
```
