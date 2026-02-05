#!/bin/bash

set -xeuo pipefail

dnf config-manager setopt keepcache=1

dnf -y copr enable bieszczaders/kernel-cachyos
dnf -y copr disable bieszczaders/kernel-cachyos
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos install \
  kernel-cachyos

dnf copr enable -y lizardbyte/beta
dnf copr disable -y lizardbyte/beta
dnf -y --enablerepo copr:copr.fedorainfracloud.org:lizardbyte:beta install \
  Sunshine

dnf -y copr enable bieszczaders/kernel-cachyos-addons
dnf -y copr disable bieszczaders/kernel-cachyos-addons
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons swap zram-generator-defaults cachyos-settings
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons install \
  scx-scheds-git \
  scx-manager

# THIS IS SO ANNOYING
# It just fails for whatever damn reason, other stuff is going to lock it if it actually fails
yes | dnf -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras,-mesa} || :
dnf config-manager setopt terra.enabled=0
dnf config-manager setopt terra-extras.enabled=0
dnf config-manager setopt terra-mesa.enabled=0

dnf -y --enablerepo=terra --enablerepo=terra-extras install \
  terra-gamescope

dnf swap --repo=terra-mesa -y mesa-filesystem mesa-filesystem
dnf -y --enablerepo=terra install \
  asusctl \
  gamescope-session-ogui-steam \
  gamescope-session-opengamepadui \
  gamescope-session-plus \
  gamescope-session-steam \
  inputplumber \
  opengamepadui \
  powerbuttond \
  powerstation \
  ScopeBuddy \
  steam-notif-daemon \
  umu-launcher \
  steamos-manager \
  steamos-manager-gamescope-session-plus

dnf -y --enablerepo=terra --enablerepo=terra-mesa install \
  -x falcond \
  steam

rm /usr/share/wayland-sessions/gamescope-session-steam.desktop # we dont want the standard session

mkdir -p /usr/share/sdl/
curl "https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/refs/heads/master/gamecontrollerdb.txt" -Lo /usr/share/sdl/gamecontrollerdb.txt

dnf install -y mangohud vulkan-tools waydroid

# We don't need this after the fetch script
dnf config-manager setopt keepcache=0

dnf info mesa-filesystem | grep -F -e "Terra"
rpm -qa | grep -v -E "^gamescope"
