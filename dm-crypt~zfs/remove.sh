#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS_DEVICES[@]}"; do
    zpool offline bpool "${disk}2" || true
    zpool offline rpool "${disk}3" || true
done
