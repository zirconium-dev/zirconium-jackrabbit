#!/bin/bash

set -xeuo pipefail

cp -avf "/ctx/files"/. /

echo "ntsync" | tee /usr/lib/modules-load.d/ntsync.conf

#TODO: Investigate inputplumber service, it seems that loading it as user is how you're supposed to do it.
#systemctl enable inputplumber
systemctl enable powerstation
