#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

# FIXME: iterate through the *_DEVICES lists.

disks=("${BOOT_DEVICES[@]}")
zpool list -vH bpool | awk '{ if ($10 == "FAULTED" || $10 == "UNAVAIL" || $10 == "OFFLINE") { print $1 } }' | while read uuid; do
    disk=${disks[0]}
    zpool replace -f bpool $uuid $disk
    disks=("${disks[@]:1}")
done

disks=("${CRYPT_DEVICES[@]}")
zpool list -vH rpool | awk '{ if ($10 == "FAULTED" || $10 == "UNAVAIL" || $10 == "OFFLINE") { print $1 } }' | while read uuid; do
    disk=${disks[0]}
    zpool replace -f rpool $uuid $disk
    disks=("${disks[@]:1}")
done

zpool wait bpool

zpool wait bpool

zpool status
