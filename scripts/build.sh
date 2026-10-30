#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
export PATH="/opt/homebrew/bin:$PATH"
cargo build --release --locked
APP="$PWD/build/SnipSnap.app"
mkdir -p "$APP/Contents/MacOS"
cp target/release/snipsnap-core "$APP/Contents/MacOS/"
swiftc -O -parse-as-library -target "$(uname -m)-apple-macosx14.0" apps/macos/SnipSnap.swift -o "$APP/Contents/MacOS/SnipSnap" -framework SwiftUI -framework AppKit -framework Vision
cp apps/macos/Info.plist "$APP/Contents/Info.plist"
codesign --force --sign - "$APP/Contents/MacOS/snipsnap-core"
codesign --force --sign - "$APP"
echo "$APP"
