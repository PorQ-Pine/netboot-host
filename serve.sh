#!/bin/bash

cd "$(dirname ""${0}"")"

BOOT_DIR="nbd/boot"
RSA_KEY="${BOOT_DIR}/rsa_hkey"
FIRMWARE_BLOB="${BOOT_DIR}/firmware.squashfs"
if [ ! -e "${RSA_KEY}" ]; then
	dropbearkey -t rsa -f "${RSA_KEY}"
fi
if [ ! -e "${FIRMWARE_BLOB}" ]; then
	wget -O "${FIRMWARE_BLOB}" "https://github.com/PorQ-Pine/firmware/raw/refs/heads/main/wifi_bt/firmware.squashfs"
fi

nbdkit -r file nbd/rootfs.squashfs -p 10809
nbdkit -r --filter=partition linuxdisk nbd/boot type=ext4 size=1G -p 10810 partition=1
