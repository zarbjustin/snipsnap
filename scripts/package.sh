#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
./scripts/build.sh
ditto -c -k --sequesterRsrc --keepParent build/SnipSnap.app build/SnipSnap-macos-arm64-dev.zip
echo "Development build only: ad-hoc signed, not notarized."
