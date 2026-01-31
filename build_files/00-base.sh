#!/bin/bash

set -xeuo pipefail

###InputPlumber
dnf -y copr enable shadowblip/InputPlumber
dnf -y copr disable shadowblip/InputPlumber
dnf -y --enablerepo copr:copr.fedorainfracloud.org:shadowblip:InputPlumber install \
  inputplumber

sudo systemctl enable inputplumber

###OpenGamepadUI

OGUI_TAG=$(curl --fail --retry 5 --retry-delay 5 --retry-all-errors -s https://api.github.com/repos/ShadowBlip/OpenGamepadUI/releases/latest | grep tag_name | cut -d : -f2 | tr -d 'v", ' | head -1)
IP_TAG=$(curl --fail --retry 5 --retry-delay 5 --retry-all-errors -s https://api.github.com/repos/ShadowBlip/InputPlumber/releases/latest | grep tag_name | cut -d : -f2 | tr -d 'v", ' | head -1)
PS_TAG=$(curl --fail --retry 5 --retry-delay 5 --retry-all-errors -s https://api.github.com/repos/ShadowBlip/PowerStation/releases/latest | grep tag_name | cut -d : -f2 | tr -d 'v", ' | head -1)

dnf install -y \
    https://github.com/ShadowBlip/OpenGamepadUI/releases/download/v$OGUI_TAG/opengamepadui-$OGUI_TAG-1.x86_64.rpm \
    https://github.com/ShadowBlip/InputPlumber/releases/download/v$IP_TAG/inputplumber-$IP_TAG-1.x86_64.rpm \
    https://github.com/ShadowBlip/PowerStation/releases/download/v$PS_TAG/powerstation-$PS_TAG-1.x86_64.rpm

###Other

dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf -y config-manager --set-disabled terra-release

dnf -y --enablerepo terra-release install \
	gamescope-session-plus

dnf install -y \
	steam \
