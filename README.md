# raid explorations

## procedure

**WARNING**: following these instructions by default will destroy
all data on `/dev/sd{a,b,c,d}`. It is only recommended to run these
scripts in a VM or on a machine with no important data.

Boot Debian LiveCD.

```
sudo -i

apt update && apt install -y vim git

git clone https://github.com/khimaros/raid-explorations

cd raid-explorations
```

Adjust `default` symlink and edit `config.sh`.

Start the installation:

```
./run.sh
```

Reboot.

## discoveries

### dm-integrity + md considered harmful

tl;dr, on a system with four 10GiB drives in a RAID-5 configuration using the
setup described above, **200 bytes of randomly distributed corruption across
two drives (in non-overlapping stripes) could result in unrecoverable failure
of the entire array**.

I've been battle testing this setup for the past few days. It is much easier
to repair bad checksums on a dm-integrity device before stopping the md array.
If you stop the array and re-assemble, any dm-integrity device with checksum
errors will refuse to reattach.

```
# mdadm --manage /dev/md0 --add /dev/mapper/sda3_int
[ ... ] Buffer I/O error on dev dm-3, logical block 2324464, async page read
[ ... ] Buffer I/O error on dev dm-3, logical block 2324493, async page read
[ ... ] Buffer I/O error on dev dm-3, logical block 2324494, async page read
[ ... ] Buffer I/O error on dev dm-3, logical block 2324494, async page read
[ ... ] Buffer I/O error on dev dm-3, logical block 0, async page read
[ ... ] Buffer I/O error on dev dm-3, logical block 0, async page read
mdadm: Failed to write metadata to /dev/mapper/sda3_int
```

In these cases, even mapping the device with `--integrity-no-journal` or
`--integrity-recovery-mode` does not convince md to accept the device back
into the pool.

```
# integritysetup close sda3_int
# integritysetup open --integrity sha256 /dev/sda3 sda3_int
[ ... ] device-mapper: integrity: Error on journal commit id: -5
[ ... ] Buffer I/O error on dev dm-3, logical block 2324464, async page read
# integritysetup close sda3_int
# integritysetup open --integrity sha256 -D -R /dev/sda3 sda3_int
# mdadm --manage /dev/md0 --add /dev/mapper/sda3_int
[ ... ] Buffer I/O error on dev dm-3, logical block 1, async page write
```

The only way I've found to recover a disk is to completely wipe the integrity
device and add it back to the array:

```
# integritysetup close sda3_int
# integritysetup format --integrity sha256 /dev/sda3
Formatted with tag size 4, internal integrity sha256.
Wiping device to initialize integrity checksum.
# integritysetup open --integrity sha256 /dev/sda3 sda3_int
# mdadm --manage /dev/md0 --add /dev/mapper/sda3_int
mdadm: added /dev/mapper/sda3_int
```

In my own testing, I've found that as few as 100 random byte manipulations of
the underlying 10GiB block device (avoiding the first 20MiB and last 16MiB of
the partition) can result in an unrecoverable error on the dm-integrity device.

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

My undestanding is that dm-integrity could drastically increase the likelihood
of a full array failure. The risk of this compared with silent bit rot seems to
be significant. The cure may be worse than the poison.

## experiments

### random\_write

Write random byte content to random positions within a file.

This can be used on block devices, for example, to test RAID or integrity behavior.

#### usage

```
./random_write.py <path> <bytes> [start_pad] [end_pad]
```

#### examples

Write 1 byte to a random location on /dev/sdb4:

```
./random_write.py /dev/sdb4 1
```

Write 1000 bytes to /dev/sdb4:

```
./random_write.py /dev/sdb4 1000
```
