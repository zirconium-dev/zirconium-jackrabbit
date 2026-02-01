#!/bin/bash

set -xeuo pipefail

for pkg in kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra; do
  rpm --erase $pkg --nodeps
done

pushd /usr/lib/kernel/install.d
printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install
chmod +x  05-rpmostree.install 50-dracut.install
popd
