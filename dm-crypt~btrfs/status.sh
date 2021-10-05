#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

btrfs filesystem show /

btrfs device stats /

btrfs scrub status -d /

echo "checksum errors:"

dmesg -c | grep "checksum error at" | grep "(path:" | sed -n -r 's#.*BTRFS.*i/o error.*path: (.*)\)#\1#p'
