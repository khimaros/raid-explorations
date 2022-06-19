#!/bin/bash

set -e

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

#mdadm --detail ${BOOT_MD_DEVICE}

mdadm --detail ${ROOT_MD_DEVICE}
echo
