# Workflow specifications

## Capture and export (P0)

Input: user chooses Region, Window or Main Display. Hide the studio before capture; invoke the native picker through Rust. For Region, drag a rectangle; for Window, click a window. Escape leaves the existing source untouched. Permission/cancellation failures restore the app and show a useful message. Load only a successful, decodable image.

Output: source-resolution preview, pixel dimensions, empty editable annotation stack. Draw an arrow, rectangle or line in image coordinates. Undo removes the latest mark; redo restores it; a new mark clears redo. Copy flattens through the same Rust renderer as export. PNG export asks for a destination in a native save dialog and preserves the source bytes.

Acceptance: capture a synthetic target, verify dimensions and content, add a mark, undo/redo it, export, decode and inspect output pixels. Deny/cancel capture and confirm no stale screenshot is loaded. Repeat at 1×/2× display scale before claiming broad Retina coverage.

## OCR (P1)

Input: current source image. Invoke local Vision text recognition off the main thread. Output: selectable/editable text in a sheet with Copy Text. Empty recognition has an explicit message. OCR currently reads the original source; flattened annotations are not OCR input.

Acceptance: capture or import known text and confirm expected words appear. No remote OCR services, telemetry or uploads.

## Future vertical slices

Project persistence: versioned image plus editable layers; reopening preserves editing and undo semantics. Library: local storage, stable capture IDs, metadata search and graceful missing-file handling. Recording: explicit source/audio choice, elapsed time, stop/pause controls and decodable output. Scrolling: supported-host capability checks and clear unsupported results. These workflows are planned, not implemented.
