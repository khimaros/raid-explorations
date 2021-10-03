#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/common.sh"

mdadm --action=check /dev/${BOOT_MD}

mdadm --wait /dev/${BOOT_MD}

mdadm --detail /dev/${BOOT_MD}

mdadm --action=check /dev/${ROOT_MD}

mdadm --wait /dev/${ROOT_MD}

mdadm --detail /dev/${ROOT_MD}
