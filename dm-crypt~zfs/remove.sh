#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

for disk in "${DISKS[@]}"; do
    dev="/dev/${dev}"
    zpool offline bpool "${dev}2" || true
    zpool offline rpool "${dev}3" || true
		cryptsetup luksClose "${disk}3_crypt" || true
done
