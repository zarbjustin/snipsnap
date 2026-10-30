# Bounded Snagit investigation

## Verified observations

E01: REA inspect-plist identifies Snagit 2026.4.3, its bundle identifier and declared image/document types. It declares camera/microphone usage descriptions. Declarations do not prove recording behaviour.

E02: REA inspect-macho identifies a universal x86_64/arm64 executable. Native inspection lists links to SwiftUI, Vision, CoreML, AVFoundation and multiple vendor frameworks. A linked framework does not establish which feature invokes it or how it is implemented.

E03: Normal accessibility inspection exposed Editor, Library, Assets, Capture, Create, Arrow, Text, Callout, Shape, Stamp, Fill, Move, Selection, Copy All and sharing controls. The arrow properties expose width, opacity, colour, head/tail styles and shadow controls. These are observed controls; complete workflows were not exercised.

E04: File menu exposes new image/capture, open, save/as, duplicate, import, batch export and print commands. Existing user captures were not inspected, modified, exported or uploaded for research. Open document names and recents are excluded from committed evidence.

## Limits

Initial UI discovery timed out; retry with the verified bundle identifier succeeded. No code bodies or proprietary assets were extracted. Capture, recording, OCR, scrolling capture and library behaviour in Snagit are untested in this investigation. Their expected capabilities are product requirements from the user's brief, not verified feature parity.

This is behaviour-based independent implementation in one engineering environment, not an independently isolated legal clean-room process. Stronger separation would require distinct research/implementation environments. The implementation has not consumed decompiled code.
