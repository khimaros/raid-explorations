#!/bin/bash

set -e

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

zpool status bpool

zpool status rpool
