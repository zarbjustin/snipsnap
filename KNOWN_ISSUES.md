# Known issues and limits

## Release blockers

- Development build is ad-hoc signed only. No Developer ID identity was available; no notarization occurred. Distribution and permission identity stability across rebuilds need release engineering.
- Capture currently delegates to macOS screencapture. Window and main-display modes are implemented but have not completed the manual acceptance matrix. Full-display means main display only. Global hotkey and multi-display/Spaces coverage remain missing.
- First capture may wait for a macOS privacy prompt. Screen access must be approved in System Settings; permission denial and Escape currently share an error message. UI automation could not operate the system picker, so real capture was user-assisted.
- No persistent project format or library yet. Closing the application loses the editable annotation list and temporary source. Export or copy before quitting. No unsaved-work close warning yet.

## Editor and service gaps

- Fixed red style and width; arrow/rectangle/line only. No object selection/reposition, text, freehand, crop/resize, blur, effects, templates or canvas zoom.
- Rust export edges are not anti-aliased like SwiftUI preview. Colour profile preservation and a broader image-quality test suite remain work. Straight-alpha compositing has a regression test; JPEG composites transparency onto white.
- OCR reads source pixels rather than flattened annotations; recognition accuracy has only one local manual case. Vision stays native; Rust OCR abstraction/search metadata is future work.
- PNG is the UI export format. JPEG is available through the core CLI only.
- Image/JSON sizes and decoder allocations are bounded and export is atomic. Total rendering work across many large diagonal annotations still needs a tighter execution budget before untrusted-file release use.
- Screen recording, audio, scrolling capture, library/search and advanced sharing are missing. No performance-parity claims.

## Environment

- REA 6.7.0 lacks inspect-desktop-application documented on main. inspect-macho/inspect-plist work. No decompiler installed. Codex restart needed for new MCP discovery.
- Full Xcode and signing credentials were unavailable. CLT SwiftUI @State macro plugin was missing; editor state is held in an ObservableObject as a compatible implementation.
- Shell git push lacks authentication. Publication uses the connected GitHub API.
