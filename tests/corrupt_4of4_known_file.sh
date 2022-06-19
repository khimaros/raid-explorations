#!/bin/bash

set -ex

FILE_OFFSET=$(grep --only-matching --byte-offset --max-count=1 --text "# Magic local data" | cut -d: -f1)

for disk in sd{a,b,c,d}; do
  dd if=/dev/random of=/dev/${disk} oflag=seek_bytes seek=${FILE_OFFSET} count=30
done
