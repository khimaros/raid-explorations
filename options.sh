###################################
# INTERNAL ONLY BEYOND THIS POINT #
###################################

DISKS=($(eval echo "$DISKS_GLOB"))

DISKS_DEVICES=($(eval echo "/dev/${DISKS_GLOB}"))

EFI_DEVICES=($(eval echo "/dev/${DISKS_GLOB}${DISKS_PART_PREFIX}1"))

EFI_MD_NAME=efi

EFI_MD_DEVICE=/dev/md/${EFI_MD_NAME}

BOOT_DEVICES=($(eval echo "/dev/${DISKS_GLOB}${DISKS_PART_PREFIX}2"))

BOOT_MD_NAME=boot

BOOT_MD_DEVICE=/dev/md/${BOOT_MD_NAME}

if [[ -n "$REPLACE_DISKS_GLOB" ]]; then
    REPLACE_DISKS=($(eval echo "$REPLACE_DISKS_GLOB"))

    REPLACE_DISKS_DEVICES=($(eval echo "/dev/${REPLACE_DISKS_GLOB}"))

    REPLACE_EFI_DEVICES=($(eval echo "/dev/${REPLACE_DISKS_GLOB}${DISKS_PART_PREFIX}1"))

    REPLACE_BOOT_DEVICES=($(eval echo "/dev/${REPLACE_DISKS_GLOB}${DISKS_PART_PREFIX}2"))
fi
