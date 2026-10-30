# Rust engine and native macOS shell

The SwiftUI studio owns windows, system menus, dialogs, gesture feedback and local Vision calls. AppKit provides clipboard and lifecycle integration. A bundled snipsnap-core process receives argument arrays; render requests point to a bounded versioned JSON file. The Rust library validates the document, loads source pixels under decoder limits, rasterizes annotations and encodes output. Capture commands invoke the OS utility and validate the result before reporting success.

This process boundary is simple, inspectable and isolates image work from the UI thread. Its current cost is PNG decode per export and process startup. A future C ABI or persistent service is justified only by measurements. No shell interpolation or network service is used at runtime.

| Option | Assessment |
|---|---|
| SwiftUI/AppKit + Rust | Selected: native menus/dialogs, small Apple adapter surface, straightforward Vision/ScreenCaptureKit path |
| Rust Objective-C bindings | Viable future adapter; more ownership/ABI complexity for initial UI iteration |
| Tauri | Strong Rust services and cross-platform UI; webview adds a second UI stack for a Mac-only product |
| egui/eframe | Good immediate-mode tooling; extra work for native document/window/accessibility conventions |
| Slint | Declarative Rust-friendly UI; Apple media/permission adapters still required |

Coordinates: immutable source image dimensions are physical pixels. Display scale is min(view width/image width, view height/image height). Gestures divide view coordinates by that scale. Renderer uses the same endpoints, widths and arrow-head geometry. Preview is anti-aliased by SwiftUI; current Rust raster export has hard edges, so exact preview/export edge matching remains work.

Document v1 stores annotation kind, endpoints, width and RGBA colour. Rust rejects unknown versions, excessive counts, non-finite/out-of-range coordinates and unsupported tools. Source is separate; no native project persistence yet. Undo/redo currently lives in the presentation model. Future document history must become a core command model with migrations and project round-trip tests.

Future service boundaries: capture-core (ScreenCaptureKit/public permission APIs), recording-core (bounded frame queues and audio timing), image/annotation engine, document model, OCR adapter (Vision), media export, SQLite library, shortcuts and app services. Extract crates only as real responsibilities grow. Metal/CoreImage are candidates for measured rendering bottlenecks; AVFoundation/CoreMedia/CoreVideo for recording. REA is research-only and is not bundled.
