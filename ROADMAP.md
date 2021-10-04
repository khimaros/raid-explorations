# ROADMAP

```
[x] make EFI partition resilient to whole disk losses
[x] use a zpool for /boot in zfs exploration
[x] use btrfs volume for /boot in btrfs exploration
[x] settle on uuid vs. dev node ordering for crypttab
[ ] document performance characteristics of each exploration
[ ] add integrity to /boot for md exploration
[ ] force mdadm create
[ ] save password and only require typing once
[ ] remove duplicate update-initramfs invocations
[ ] create backup of cryptsetup headers (on /boot?)
[ ] write cryptsetup keys to TPM
[ ] fix bpool import / mount on startup for zfs
```
