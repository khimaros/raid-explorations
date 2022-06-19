# ROADMAP

```
[x] make EFI partition resilient to whole disk losses
[x] use a zpool for /boot in zfs exploration
[x] use btrfs volume for /boot in btrfs exploration
[x] settle on uuid vs. dev node ordering for crypttab
[x] save password and only require typing once
[x] create backup of cryptsetup headers (on /boot?)

[ ] document performance characteristics of each exploration
[ ] add integrity to /boot for md exploration
[ ] force mdadm create
[ ] remove duplicate update-initramfs invocations
[ ] write cryptsetup keys to TPM
[ ] fix bpool import / mount on startup for zfs
```
