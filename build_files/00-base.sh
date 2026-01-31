#!/bin/bash

set -xeuo pipefail

###Kernel
for pkg in kernel kernel-core kernel-modules kernel-modules-core; do
  rpm --erase $pkg --nodeps
done

pushd /usr/lib/kernel/install.d
printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install
chmod +x  05-rpmostree.install 50-dracut.install
popd

dnf -y copr enable bieszczaders/kernel-cachyos
dnf -y copr disable bieszczaders/kernel-cachyos
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos install \
  kernel-cachyos

dnf -y copr enable bieszczaders/kernel-cachyos-addons
dnf -y copr disable bieszczaders/kernel-cachyos-addons
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons swap zram-generator-defaults cachyos-settings
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons install \
  scx-scheds-git \
  scx-manager

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

sudo dnf install -y \
	steam
