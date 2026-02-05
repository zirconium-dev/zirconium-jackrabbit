#!/bin/bash

set -xeuo pipefail

cp -avf "/ctx/files"/. /

echo "ntsync" | tee /usr/lib/modules-load.d/ntsync.conf
