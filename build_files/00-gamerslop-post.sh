#!/bin/bash

set -xeuo pipefail

cp -avf "/ctx/files"/. /

echo "ntsync" | tee /usr/lib/modules-load.d/ntsync.conf

systemctl enable inputplumber
systemctl enable powerstation

KERNEL_VERSION="$(find "/usr/lib/modules" -maxdepth 1 -type d ! -path "/usr/lib/modules" -exec basename '{}' ';' | sort | tail -n 1)"
export DRACUT_NO_XATTR=1
depmod -a "$(ls -1 /lib/modules/ | tail -1)"
dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible --zstd -v --add ostree -f "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
chmod 0600 "/usr/lib/modules/${KERNEL_VERSION}/initramfs.img"
