#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

mdadm --detail /dev/${BOOT_MD}

mdadm --detail /dev/${ROOT_MD}
