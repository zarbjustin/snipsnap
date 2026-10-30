# SnipSnap

Snip it. Snap it. Done.

A native macOS capture and annotation studio with a Rust engine and a thin Apple-native interface. Work in progress; see FEATURE_PARITY.md for verified capabilities and remaining work.

## Try the development build

Requires macOS 14+, Rust/Cargo, and Apple's Swift command-line tools. The current build was tested on macOS 27.2 arm64. Intel and older macOS versions need verification.

```sh
./scripts/check.sh
./scripts/build.sh
```

Launch `build/SnipSnap.app` in Finder. Use Capture → Region, Window or Main Display. Approve Screen Recording access when macOS asks, then retry if needed. Open an image, drag to add arrows/rectangles/lines, undo/redo, copy or Export PNG. Extract Text runs locally using Vision. The core CLI also exports JPEG.

**Export before quitting:** editing is currently temporary; persistent projects and capture history are planned. App shortcuts include Shift-Command-2 (region), Command-O (open), Command-S (export), Command-Z and Shift-Command-Z. These are app-local, not global shortcuts.

`scripts/package.sh` makes a development ZIP. Builds are ad-hoc signed, not notarized. To remove, quit and delete the app. No background service is installed; transient working images are removed on normal exit. REA and Codex are not runtime dependencies.

## Engineering notes

Start with [PLAN.md](PLAN.md), [PROGRESS.md](PROGRESS.md), [TEST_RESULTS.md](TEST_RESULTS.md), [KNOWN_ISSUES.md](KNOWN_ISSUES.md) and [architecture](docs/05-architecture.md). This MVP is not full Snagit parity. Reference investigation uses metadata and visible behaviour only; no proprietary code, assets, licensing mechanisms or user captures are included.
