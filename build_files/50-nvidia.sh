#!/usr/bin/env bash

set -xeuo pipefail

if [[ ! "${BUILD_FLAVOR}" =~ "nvidia" ]] ; then
  exit 0
fi

# We just need to rebuild it since the base image already has these :)

mkdir -p /var/log/akmods /var/tmp
chmod 1777 /var/tmp
KERNEL_VERSION="$(find "/usr/lib/modules" -maxdepth 1 -type d ! -path "/usr/lib/modules" -exec basename '{}' ';' | sort | tail -n 1)"
akmods --force --kernels "${KERNEL_VERSION}" --kmod "nvidia"
cat /var/cache/akmods/nvidia/*.failed.log || true
