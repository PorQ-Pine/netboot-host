#!/bin/bash -xe

cd "$(dirname ""${0}"")"

BASE_DIR="nbd"
BOOT_DIR="${BASE_DIR}/boot"

SERVER="http://23.163.0.39/quill_netboot"

RSA_KEY="${BOOT_DIR}/rsa_hkey"
FIRMWARE_BLOB="${BOOT_DIR}/firmware.squashfs"
ROOTFS="${BASE_DIR}/rootfs.squashfs"
QINIT_BINARIES="${BOOT_DIR}/qinit_binaries.squashfs"
EBC_WBF="ebc.wbf"
CUSTOM_WF="custom_wf.bin"
EKM="eink-kernel-magic"
IMAGE="${BOOT_DIR}/Image.gz"
DTB="${BOOT_DIR}/DTB"

if [ ! -e "${RSA_KEY}" ]; then
	dropbearkey -t rsa -f "${RSA_KEY}"
fi

if [ ! -e "${FIRMWARE_BLOB}" ]; then
	wget -O "${FIRMWARE_BLOB}" "https://github.com/PorQ-Pine/firmware/raw/refs/heads/main/wifi_bt/firmware.squashfs"
fi

if [ ! -e "${ROOTFS}" ]; then
	wget -O "${ROOTFS}" "${SERVER}/rootfs.squashfs"
fi

if [ ! -e "${QINIT_BINARIES}" ]; then
	wget -O "${QINIT_BINARIES}" "${SERVER}/qinit_binaries.squashfs"
fi

if [ ! -e "${IMAGE}" ]; then
	wget -O "${IMAGE}" "${SERVER}/Image.gz"
fi

if [ ! -e "${DTB}" ]; then
	wget -O "${DTB}" "${SERVER}/DTB"
fi

[ ! -e "${EBC_WBF}" ] && [ ! -e "${EKM}/${EBC_WBF}" ] && echo "You must provide ebc.wbf. Please put it at the root directory of this repository." && exit 1
if [ ! -d "${EKM}" ]; then
	git clone "https://github.com/PorQ-Pine/${EKM}"
	pushd "${EKM}"
	mv "../${EBC_WBF}" .
	python3 wbf_to_custom.py "${EBC_WBF}"
	popd
	mkdir -p "${BOOT_DIR}/waveform"
	cp "${EKM}/${EBC_WBF}" "${EKM}/${CUSTOM_WF}" "${BOOT_DIR}/waveform"
fi

nbdkit -r file nbd/rootfs.squashfs -p 10809
nbdkit -r --filter=partition linuxdisk nbd/boot type=ext4 size=1G -p 10810 partition=1
