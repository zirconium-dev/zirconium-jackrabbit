#!/bin/bash

set -xeuo pipefail

cp -avf "/ctx/files"/. /

KERNEL_VERSION="$(find "/usr/lib/modules" -maxdepth 1 -type d ! -path "/usr/lib/modules" -exec basename '{}' ';' | sort | tail -n 1)"

dkms install -m "xone/$(basename "$(find /usr/src -iname "*xone*" -type d)" | cut -f2 -d-)" -k "${KERNEL_VERSION}"

stat "/usr/lib/modules/${KERNEL_VERSION}"/extra/xone*.ko* # We actually need the kernel objects after build LOL
