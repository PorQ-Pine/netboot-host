#!/bin/bash -x

RQ="/workspaces/quillstrap/other/path/rq"
SSH_KEY="${1}"
SSH_USER="${2}"
CONTAINER="${3}"
[ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] && echo "Not enough arguments provided." && exit 1
SSH_DIR="/root/.ssh"

run_docker_cmd() {
	docker exec -it -w /workspaces/quillstrap "${CONTAINER}" ${@}
}

rq() {
	run_docker_cmd ${RQ} ${@}
}

rq -g all
rq -m -b quill_init -b kernel
rq -m -b core_settings
rq -m -b procedural_wallpapers
rq -m -b qinit_binaries
rq -a -i -b rootfs

run_docker_cmd mkdir -p "${SSH_DIR}"
docker cp "${HOME}/.ssh/${SSH_KEY}" "${CONTAINER}:${SSH_DIR}"
docker cp "${HOME}/.ssh/${SSH_KEY}.pub" "${CONTAINER}:${SSH_DIR}"
run_docker_cmd scp /workspaces/quillstrap/build_all/init/kernel/out/Image.gz /workspaces/quillstrap/build_all/init/kernel/out/DTB /workspaces/quillstrap/build_all/init/qinit_binaries/out/qinit_binaries.squashfs /workspaces/quillstrap/build_all/os/low/rootfs/out/rootfs.squashfs ${SSH_USER}@23.163.0.39:/var/www/html/quill_netboot
