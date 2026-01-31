#!/bin/bash

set -xeuo pipefail

dnf -y copr enable bieszczaders/kernel-cachyos-lto
dnf -y copr disable bieszczaders/kernel-cachyos-lto
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-lto install \
  kernel-cachyos-lto

dnf -y copr enable bieszczaders/kernel-cachyos-addons
dnf -y copr disable bieszczaders/kernel-cachyos-addons
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons swap zram-generator-defaults cachyos-settings
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons install \
  scx-scheds-git \
  scx-manager

dnf -y copr enable shadowblip/InputPlumber
dnf -y copr disable shadowblip/InputPlumber
dnf -y --enablerepo copr:copr.fedorainfracloud.org:shadowblip:InputPlumber install \
  inputplumber

OGUI_TAG="$(curl --fail --retry 5 --retry-delay 5 --retry-all-errors -s "https://api.github.com/repos/ShadowBlip/OpenGamepadUI/releases/latest" | grep tag_name | cut -d : -f2 | tr -d 'v", ' | head -1)"
IP_TAG="$(curl --fail --retry 5 --retry-delay 5 --retry-all-errors -s "https://api.github.com/repos/ShadowBlip/InputPlumber/releases/latest" | grep tag_name | cut -d : -f2 | tr -d 'v", ' | head -1)"
PS_TAG="$(curl --fail --retry 5 --retry-delay 5 --retry-all-errors -s "https://api.github.com/repos/ShadowBlip/PowerStation/releases/latest" | grep tag_name | cut -d : -f2 | tr -d 'v", ' | head -1)"

dnf install -y \
  "https://github.com/ShadowBlip/OpenGamepadUI/releases/download/v$OGUI_TAG/opengamepadui-$OGUI_TAG-1.$(arch).rpm" \
  "https://github.com/ShadowBlip/InputPlumber/releases/download/v$IP_TAG/inputplumber-$IP_TAG-1.$(arch).rpm" \
  "https://github.com/ShadowBlip/PowerStation/releases/download/v$PS_TAG/powerstation-$PS_TAG-1.$(arch).rpm"

dnf copr enable -y lizardbyte/beta
dnf copr disable -y lizardbyte/beta
dnf -y --enablerepo copr:copr.fedorainfracloud.org:lizardbyte:beta install \
  Sunshine

# THIS IS SO ANNOYING
# It just fails for whatever damn reason, other stuff is going to lock it if it actually fails
yes | dnf -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras,-mesa} || :
dnf config-manager setopt terra.enabled=0
dnf config-manager setopt terra-extras.enabled=0
dnf config-manager setopt terra-mesa.enabled=0

dnf swap --repo=terra-mesa -y mesa-filesystem mesa-filesystem
dnf -y --enablerepo=terra install \
  gamescope-session-plus \
  ScopeBuddy

dnf -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-steam.repo
dnf config-manager setopt fedora-steam.enabled=0

dnf install -y --enablerepo=fedora-steam --enablerepo=terra-mesa -x gamemode steam

dnf install -y mangohud lutris vulkan-tools

