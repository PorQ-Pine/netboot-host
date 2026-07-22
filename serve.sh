#!/bin/bash

cd "$(dirname ""${0}"")"

BOOT_DIR="nbd/boot"
RSA_KEY="${BOOT_DIR}/rsa_hkey"
if [ ! -e "${RSA_KEY}" ]; then
	dropbearkey -t rsa -f "${RSA_KEY}"
fi

nbdkit -r file nbd/rootfs.squashfs -p 10809
nbdkit -r --filter=partition linuxdisk nbd/boot type=ext4 size=1G -p 10810 partition=1
