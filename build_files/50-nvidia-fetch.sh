#!/usr/bin/env bash

set -xeuo pipefail

if [[ ! "${BUILD_FLAVOR}" =~ "nvidia" ]] ; then
  exit 0
fi

# Strictly required for nvidia image kernel module building specifically, so not on gamerslop-fetch


dnf config-manager setopt keepcache=1

dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos install \
  kernel-cachyos-devel

dnf config-manager setopt keepcache=0
