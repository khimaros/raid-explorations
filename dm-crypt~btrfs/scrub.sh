#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

log_path=/tmp/raid-explorations.$$

for disk in "${CRYPT_DEVICES[@]}"; do
    btrfs scrub start -B "$disk" >> $log_path || true
done

cat $log_path

rm -f $log_path

for disk in "${CRYPT_DEVICES[@]}"; do
	btrfs device stats -z "$disk"
done
