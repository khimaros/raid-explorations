#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

btrfs filesystem show /

btrfs device stats /

btrfs scrub status -d /
