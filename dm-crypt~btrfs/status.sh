#!/bin/bash

set -e

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/../options.sh"
. "$(dirname "$0")/common.sh"

btrfs filesystem show /

btrfs device stats /

btrfs scrub status -d /

echo
echo "checksum errors:"
echo
dmesg -c | grep "checksum error at" | grep "(path:" | sed -n -r 's#.*BTRFS.*i/o error.*path: (.*)\)#\1#p'
