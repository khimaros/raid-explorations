#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/../options.sh"
. "$(dirname "$0")/common.sh"

#mdadm --action=check ${BOOT_MD_DEVICE}

#mdadm --wait ${BOOT_MD_DEVICE}

mdadm --action=check ${ROOT_MD_DEVICE}

mdadm --wait ${ROOT_MD_DEVICE}
