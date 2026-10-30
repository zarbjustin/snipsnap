# Engineering decisions

- Native SwiftUI/AppKit interface, Rust core. Avoid webview overhead and retain system dialogs, menu bar, VoiceOver labels and platform conventions.
- MVP process boundary rather than C ABI: versioned JSON edit data and explicit argument arrays to a bundled Rust executable. Image processing and capture orchestration run off the UI thread. REA is never a runtime dependency.
- Rust owns raster annotation geometry, validation, source-pixel coordinates and PNG/JPEG encoding. Swift owns native interaction, transient undo/redo stacks and a small Vision adapter. Move persistent document history into Rust when project persistence is introduced.
- Start with the system screencapture executable for authentic region/window selection, Escape handling and native pixel resolution. This is a transitional public macOS utility adapter, not a claim to a ScreenCaptureKit Rust backend. Replace behind the same service boundary before advanced capture/recording.
- All annotation coordinates are top-left source pixels. View scale is calculated once from image dimensions; display points never become stored pixel dimensions.
- Original image and editable annotation list remain separate. Export produces flattened output. Persistent editable project save/reopen is still required.
- Single core crate until domain boundaries justify extraction. Do not add empty recording/library/shortcut crates.
- No proprietary assets, decompiled bodies, activation modifications or protected file contents copied. Reference evidence is restricted to metadata and visible controls; implementation follows behaviour requirements and public Apple facilities.
- Empty remote repository requires a baseline for a PR. Initialize main with README only, then publish the implementation on feat/native-capture-mvp. Preserve the local bootstrap commit under archive/local-bootstrap.
