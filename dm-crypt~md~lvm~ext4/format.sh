#!/bin/bash

set -ex

. "$(dirname "$0")/../config.sh"
. "$(dirname "$0")/../options.sh"
. "$(dirname "$0")/common.sh"

mdadm --zero-superblock "${ROOT_DEVICES[@]}" || true

mdadm --create --name=${ROOT_MD_NAME} --level=${RAID_LEVEL} --raid-devices=4 --bitmap=internal ${ROOT_MD_DEVICE} "${ROOT_DEVICES[@]}"

wipefs -a ${ROOT_MD_DEVICE}

pvcreate ${ROOT_MD_DEVICE}

vgcreate vg0 ${ROOT_MD_DEVICE}

lvcreate --extents=90%FREE --name=root vg0

mkfs.ext4 -m 0 /dev/vg0/root

mount /dev/vg0/root /mnt
