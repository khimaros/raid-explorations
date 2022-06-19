# test explanations

 test                                  | description
 ------------------------------------- | -----------
 install and boot                      | self evident
 sysbench fileio rndwr                 | random file write/read performance (total, 95th percentile)
 sysbench fileio seqwr                 | sequential file write/read performance (total, 95th percentile)
 corrupt 50kb 2/4 data (survive)       | critical files are readable after corruption of the "data" portion of the root partition
 corrupt 50kb 2/4 data (reboot)        | boots without interaction after corruption
 corrupt 50kb 2/4 data (clean)         | scrub produces a clean array + survive
 truncate 2/4 disk (survive)           | critical files are readable after truncation of the entire disk image
 truncate 2/4 disk (reboot)            | boots without interaction
 truncate 2/4 disk (clean)             | replace produces clean array + survive
 corrupt 50kb 2/4 part (survive)       | critical files are readable
 corrupt 50kb 2/4 part (reboot)        | boots to initramfs and is recoverable
 corrupt 50kb 2/4 part (clean)         | replace produces clean array + survive
 corrupt 50kb 2/4 disk (survive)       | critical files are readable
 corrupt 50kb 2/4 disk (reboot)        | boots to initramfs and is recoverable
 corrupt 50kb 2/4 disk (clean)         | replace produces clean array + survive

## reproduction

install the system and boot into it

```
# cd raid-explorations
# ./tests/survival.sh
# ./tests/benchmark.sh
# ./tests/corrupt_2of4_data.sh
# ./tests/survival.sh
# reboot
```

restore the corrupted array

edit config.sh as needed to specify the replacement drives.

```
# cd raid-explorations
# ./tests/survival.sh
# ./replace.sh
# reboot
# ./tests/survival.sh
```

# common issues

## md without dm-integrity

THIS SHOULD NEVER BE USED FOR CRITICAL DATA.

when mdraid is running on top of block devices without dm-integrity,
it is impossible to know which device has the right bytes.

this can result in corrupted data being silently returned to the
filesystem layer and in the worst case can result in valid data
being overwritten with invalid data on the failing drive.

## md without dm-integrity (boot)

see also: `common issues > md without dm-integrity`

### symptom

this most commonly surfaces as `XZ-compressed data is corrupt`
when choosing a boot kernel in GRUB.

due to lack of dm-integrity on the boot md array, corruption of
any of the disks can result in junk data being replicated
onto the remaining healthy drives.

this can corrupt the kernel or initrd, preventing boot. often,
the data is unrecoverable and the boot partition needs to be
recreated from scratch.

### solution

FIXME: focus this on repairing the /boot array. after boot
is fixed, the replacement steps can be handled done inside
the main system installation.

boot into the live image.

clone raid-explorations repo and hand edit `config.sh` to match
whatever was used during installation.

add the failed drives to `REPLACE_DISKS`. double check that
they are the right drives with `lsblk`

to access the data run `rescue.sh` and check `/mnt`.

to prevent further corruption of the boot partition, it
is wise to run `remove.sh` before reading any data.

after verifying that the data is readable, replace the
failed disks by running `replace.sh`.

## missing block device (boot)

### symptom

unable to mount /boot during systemd init

dropped to a systemd recovery prompt

### solution

```
(initramfs) mdadm --run /dev/md127
```

continue with any stack-specific resolution.

## corrupted md headers

## corrupted dm-crypt headers

### symptom

requests password for corrupted disk ~10 times. you can just press
enter for each of the corrupted disks.

eventually drops to initramfs.

### solution

open the remaining crypt devices:

```
(initramfs) cryptsetup luksOpen /dev/sdb3 sdb3_crypt
(initramfs) cryptsetup luksOpen /dev/sdd3 sdd3_crypt
```

continue with any stack-specific resolution.

# dm-crypt~md~lvm~ext4 (data=6, csum=hmac-sha256) @ linux-5.10, bios

 test                                  | result
 ------------------------------------- | ------
 install and boot                      | ✓
 sysbench fileio rndwr                 | 
 sysbench fileio seqwr                 | 
 corrupt 50kb 2/4 data (survive)       | ✓
 corrupt 50kb 2/4 data (reboot)        | ✓
 corrupt 50kb 2/4 data (clean)         | ✓ (scrub)
 truncate 2/4 disk (survive)           | ✓
 truncate 2/4 disk (reboot)            | ✓
 truncate 2/4 disk (clean)             | ✓
 truncate 2/4 alt disk (survive)       |
 truncate 2/4 alt disk (reboot)        |
 truncate 2/4 alt disk (clean)         |
 corrupt 50kb 2/4 part (survive)       | ✓
 corrupt 50kb 2/4 part (reboot)        | ⚠
 corrupt 50kb 2/4 part (clean)         | ✓ (replace)
 corrupt 50kb 2/4 disk (survive)       | ✓
 corrupt 50kb 2/4 disk (reboot)        | ⚠
 corrupt 50kb 2/4 disk (clean)         | ✖ (replace)

## corrupt 50kb 2/4 part (reboot)

result: ⚠

see also: `common issues > corrupted dm-crypt headers`

start the root md array:

```
(initramfs) mdadm --run /dev/md126
```

continue booting with Ctrl+D.

systemd continues to try starting the dm-crypt devices
which needs interaction on the console.

eventually the system boots.

## corrupt 50kb 2/4 disk (reboot)

FIXME: NEEDS FURTHER EXAMINATION

result: ⚠

see also: `common issues > md without dm-integrity (boot)`

## corrupt 50kb 2/4 disk (clean)

FIXME: NEEDS FURTHER EXAMINATION

result: ✖

booted into a live image.

root array assembled with missing disks and mounted.

scrubbed root md without error.

could not map the target dm-crypt devices due to corrupted headers.

might have been possible to `luksRestoreHeader --header-backup-file`

# dm-crypt~btrfs (data=raid1c3, meta=raid1c4) @ linux-5.10, bios

 test                                  | result
 ------------------------------------- | ------
 install and boot                      | ✓
 sysbench fileio rndwr                 | 29.72s, 55.33ms
 sysbench fileio seqwr                 | 55.42s, 30.26ms
 corrupt 50kb 2/4 data (survive)       | ✓
 corrupt 50kb 2/4 data (reboot)        | ✓
 corrupt 50kb 2/4 data (clean)         | ✓ (scrub)
 truncate 2/4 disk (survive)           | ✓
 truncate 2/4 disk (reboot)            | ⚠
 truncate 2/4 disk (clean)             | ✓ (replace)
 truncate 2/4 alt disk (survive)       | ✓
 truncate 2/4 alt disk (reboot)        | ⚠
 truncate 2/4 alt disk (clean)         | ✓ (replace)
 corrupt 50kb 2/4 part (survive)       | ✓
 corrupt 50kb 2/4 part (reboot)        | ⚠
 corrupt 50kb 2/4 part (clean)         |
 corrupt 50kb 2/4 disk (survive)       |
 corrupt 50kb 2/4 disk (reboot)        |
 corrupt 50kb 2/4 disk (clean)         |

## truncate 2/4 disk (reboot)

result: ⚠

see also: `common issues > missing block device (boot)`

```
(initramfs) mount -o degraded /dev/mapper/sdb3_crypt /root
(initramfs) exit
```

it takes ~90 seconds to resume the boot process.

## truncate 2/4 alt disk (reboot)

same as `truncate 2/4 disk (reboot)`

## corrupt 50kb 2/4 part (reboot)

result: ⚠

see also: `common issues > corrupted dm-crypt headers`

after preparing the healthy crypt devices, mount the
btrfs filesystem as degraded and continue booting.

you often need to "exit" or Ctrl+D twice:

```
(initramfs) mount -o degraded /dev/mapper/sdd3_crypt /root
(initramfs) exit
(initramfs) exit
```

after this, you'll be asked for crypt password for the failing
disks several times again. press enter at each prompt.

# dm-integrity~md~dm-crypt~lvm~ext4 (data=6, csum=sha256) @ linux-5.10, bios

 test                                  | result
 ------------------------------------- | ------
 install and boot                      | ✓
 sysbench fileio rndwr                 | 63.35s, 44.98ms
 sysbench fileio seqwr                 | 62.38s, 38.94ms
 corrupt 50kb 2/4 data (survive)       | ✓
 corrupt 50kb 2/4 data (reboot)        | ✓
 corrupt 50kb 2/4 data (clean)         | ✓
 truncate 2/4 disk (survive)           | ✓
 truncate 2/4 disk (reboot)            | ✓
 truncate 2/4 disk (clean)             | ✓
 truncate 2/4 alt disk (survive)       | ✓
 truncate 2/4 alt disk (reboot)        | ✓
 truncate 2/4 alt disk (clean)         | ✓
 corrupt 50kb 2/4 part (survive)       | ✓
 corrupt 50kb 2/4 part (reboot)        | ✓
 corrupt 50kb 2/4 part (clean)         | ✓
 corrupt 50kb 2/4 disk (survive)       | ✓
 corrupt 50kb 2/4 disk (reboot)        | ⚠
 corrupt 50kb 2/4 disk (clean)         | ✓ (rescue + replace)

## corrupt 50kb 2/4 disk (reboot)

result: ⚠

see also: `common issues > md without dm-integrity (boot)`

