# Feature inventory and acceptance targets

Reference confidence is limited to the evidence column; unknown features come from the user brief, not an assertion about installed Snagit. Each row groups closely related acceptance targets. E01–E04 are in the evidence register. Priorities are engineering order, not a parity promise.

| Feature | Reference evidence | Input / output | Dependencies | Complexity | Priority | SnipSnap status | Acceptance test |
|---|---|---|---|---|---|---|---|
| Full-screen / display selection | Capture control only | screen / PNG | screencapture; later ScreenCaptureKit | M | P0 | Implemented main display; unverified | Capture known desktop target; check pixel dimensions |
| Region | Capture control only | drag / PNG | System picker | M | P0 | Verified user-assisted | Select region; compare decoded content |
| Window | Capture control only | click window / PNG | System picker | M | P0 | Implemented; unverified | Capture synthetic window with and without shadow |
| Delayed / menu capture | Unknown | delay, menu / PNG | Capture service | M | P2 | Missing | Open transient menu then capture after delay |
| Multi-monitor / Spaces / Retina | Unknown | display and scale / pixels | ScreenCaptureKit; coordinate transforms | H | P0 | Partial pixel design | Mixed-scale and negative-origin display matrix |
| Capture cursor / shortcuts | Unknown | toggle or key / capture | CoreGraphics; Carbon hotkey | M | P1 | Local shortcut only | Outside app focus invoke configured key |
| Screen / region / window recording | Video menu; metadata declarations | source / recording | ScreenCaptureKit; CoreMedia; AVFoundation | H | P1 | Missing | Record synthetic motion; decode frame timestamps |
| Microphone / system audio | Usage descriptions only | authorized audio / tracks | ScreenCaptureKit; AVFoundation | H | P1 | Missing | Verify audible tracks and drift without private content |
| Pause / resume / controls / video export | Unknown | commands / valid video | Recording state machine; encoders | H | P1 | Missing | Pause/resume/stop; decode complete file |
| Crop / resize / canvas | Resize control observed | bounds / edited document | Rust image engine | M | P1 | Missing | Known grid transforms and undo |
| Arrows / lines / rectangles | Arrow and Shape controls | drag / editable marks | Rust renderer; SwiftUI Canvas | M | P0 | Arrow UI verified; other UI pending | Exact pixel endpoints; reverse drag; export |
| Circles / freehand / text / callouts / steps | Text/Callout/Shape controls | gesture or text / layers | Document model; text metrics | H | P1 | Missing | Export and reopen with retained geometry |
| Highlight / blur / pixelation / redaction | Unknown | area / local effect | Rust image pipeline | H | P1 | Missing | Verify redaction export removes underlying detail |
| Object select / move / group / layer / align | Move and Selection controls | objects / transforms | Rust commands; hit testing | H | P1 | Missing | Overlapping-object edit and undo history |
| Undo / redo | Unknown | command / history | Swift model; later Rust history | M | P0 | Implemented; UI pending | Undo twice; redo; new mark clears redo |
| Zoom / effects / presets / templates | Zoom/Effects and template commands | selection / view or layers | Native view; Rust document | M | P2 | Missing | Scale cursor mapping and reusable style |
| PNG / JPEG / clipboard | Save/Copy controls; image types | image / raster | Rust image codec; NSPasteboard | M | P0 | PNG UI verified; JPEG CLI verified | Decode dimensions/pixels and preserve source |
| Editable projects / migrations | snagx declared only | project / editable document | Versioned core schema | H | P1 | Missing | Save/reopen/edit; reject future version |
| OCR / selectable image text | Vision linked only | source / recognized text | Apple Vision adapter | M | P1 | OCR manual verified | Known text match; empty/corrupt inputs |
| Sensitive-data detection / object removal | Unknown | image / suggestion or repaired result | Local models; user confirmation | H | P3 | Missing | Labeled synthetic accuracy and destructive-data checks |
| Composition / scrolling / panorama | Unknown | images or scroll / composed image | Rust compositing; supported host adapters | H | P2 | Missing | Seams, overlap, unsupported-host reporting |
| Library / thumbnails / search / tags / recents | Library and Tag controls | capture / local index | SQLite; filesystem; OCR metadata | H | P1 | Missing | Restart, search, missing file and tag round-trip |
| Naming / clipboard / drag-drop / native share | Copy and Share controls | gesture / local export | AppKit; NSSharingService | M | P1 | Copy implemented; rest missing | Drag to Finder and share selected synthetic file |
| Cloud export | Share Link control only | explicit destination / upload | Optional provider adapter | H | P3 | Missing | Explicit user destination; no automatic upload |
| Menu bar / Dock / keyboard / notifications | Unknown | native controls / action | SwiftUI; AppKit | M | P0 | Menu bar and app shortcuts implemented | Command availability with/without open window |
| Permissions / login launch / dark-light / accessibility | Unknown | system state / onboarding | Public permission and login APIs | H | P0 | Permission path partial; dark UI seen | Denial/retry, keyboard/VoiceOver and appearance matrix |
| Packaging / signing / uninstall | Unknown | release / app installer | codesign; notarytool; packaging | H | P0 | Ad-hoc app; no notarization | Clean-machine install, verify, launch and remove |
