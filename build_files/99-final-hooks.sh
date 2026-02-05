#!/usr/bin/env bash

set -xeuo pipefail

sed -i -f - /usr/lib/os-release <<EOF
s|^NAME=.*|NAME=\"Zirconium Jackrabbit\"|
s|^PRETTY_NAME=.*|PRETTY_NAME=\"Zirconium Jackrabbit\"|
EOF

echo 'import "/usr/share/zirconium/just/67-gamerslop.just"' >> /usr/share/zirconium/just/00-start.just

KERNEL_VERSION="$(find "/usr/lib/modules" -maxdepth 1 -type d ! -path "/usr/lib/modules" -exec basename '{}' ';' | sort | tail -n 1)"
export DRACUT_NO_XATTR=1
dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible --zstd -v --add ostree -f "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
chmod 0600 "/usr/lib/modules/${KERNEL_VERSION}/initramfs.img"
