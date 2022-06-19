#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/../options.sh"
. "$(dirname "$0")/common.sh"

for disk in "${REPLACE_DISKS[@]}"; do
    cryptsetup luksClose "${disk}3_crypt" || true
done
