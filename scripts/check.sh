#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
export PATH="/opt/homebrew/bin:$PATH"
cargo fmt --check
cargo clippy --workspace --all-targets --locked -- -D warnings
cargo test --workspace --locked
./scripts/build.sh
codesign --verify --deep --strict build/SnipSnap.app
plutil -lint apps/macos/Info.plist
