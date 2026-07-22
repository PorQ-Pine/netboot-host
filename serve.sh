#!/bin/bash

cd "$(dirname ""${0}"")"

nbdkit -r file nbd/rootfs.squashfs -p 10809
nbdkit --filter=cow --filter=partition linuxdisk nbd/boot type=ext4 size=1G -p 10810 partition=1
