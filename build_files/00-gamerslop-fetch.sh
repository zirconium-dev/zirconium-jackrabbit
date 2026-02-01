#!/bin/bash

set -xeuo pipefail

dnf config-manager setopt keepcache=1

dnf -y copr enable bieszczaders/kernel-cachyos
dnf -y copr disable bieszczaders/kernel-cachyos
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos install \
  kernel-cachyos

dnf -y copr enable lukenukem/asus-linux
dnf -y copr disable lukenukem/asus-linux
dnf -y --enablerepo copr:copr.fedorainfracloud.org:lukenukem:asus-linux install \
  asusctl

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

mkdir -p /usr/share/sdl/
curl "https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/refs/heads/master/gamecontrollerdb.txt" -Lo /usr/share/sdl/gamecontrollerdb.txt

mkdir -p /usr/share/gamescope-session-plus/
curl --retry 3 -Lo /usr/share/gamescope-session-plus/bootstrap_steam.tar.gz https://large-package-sources.nobaraproject.org/bootstrap_steam.tar.gz
dnf swap --repo=terra-mesa -y mesa-filesystem mesa-filesystem
dnf -y --enablerepo=terra install \
  gamescope-session-plus \
  gamescope-session-steam \
  ScopeBuddy

# im not packaging this lilbro :holding_back_tears:
OGUI_SESSION_TMPDIR="$(mktemp -d)"
curl -fsSLo - "https://github.com/ShadowBlip/gamescope-session-opengamepadui/archive/refs/heads/main.tar.gz" | tar -xzvf - -C "${OGUI_SESSION_TMPDIR}" # 67
cp -avf "${OGUI_SESSION_TMPDIR}"/*/. /
stat /usr/share/wayland-sessions/gamescope-session-opengamepadui.desktop
rm -rf "${OGUI_SESSION_TMPDIR}"

dnf -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-steam.repo
dnf config-manager setopt fedora-steam.enabled=0

dnf install -y --enablerepo=fedora-steam --enablerepo=terra-mesa -x gamemode steam

dnf install -y mangohud vulkan-tools waydroid

# We don't need this after the fetch script
dnf config-manager setopt keepcache=0
