#!/bin/bash

cd "$(dirname ""${0}"")"

nbdkit -f -v -r file nbd/rootfs.squashfs
