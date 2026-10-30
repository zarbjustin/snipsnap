# Feature parity

Status applies to SnipSnap. Snagit controls observed do not prove end-to-end reference behaviour. Requirements not observed in Snagit are explicitly unverified reference targets. Detailed requirements, dependencies and acceptance checks are in docs/02-feature-inventory.md.

| Feature | Snagit evidence | SnipSnap | Verification |
|---|---|---|---|
| Region screenshot | Capture control observed; reference workflow untested | Working | User-assisted real 820×442 capture |
| Main-display screenshot | Requirement; reference untested | Implemented, unverified | Manual test pending |
| Window screenshot | Requirement; reference untested | Implemented, unverified | Manual test pending |
| Native preview | Editor observed | Working | Synthetic image and real capture |
| Arrow | Tool/properties observed | Basic fixed red arrow | UI drawing + decoded export |
| Rectangle/line | Shape control observed | Implemented | Raster unit test; UI matrix pending |
| Undo/redo | Reference untested | Working for annotation stack | Native UI removed/restored arrow |
| PNG export | Save/as controls observed | Working | UI + core integration |
| JPEG export | Image type declared | Core CLI only | Decode/dimensions integration |
| Clipboard | Copy All control observed | Copy command verified | Native command succeeded; destination paste pending |
| Menu bar/local shortcuts | Reference untested | Implemented | Launch verified; command matrix pending |
| Global shortcut | Requirement | Missing | Planned |
| Permission handling | Reference untested | Partial | Denial + user-approved success observed |
| OCR | Vision dependency only; reference workflow untested | Local Vision adapter | Expected text returned |
| Projects/capture library/search/tags | Library control observed | Missing | Planned |
| Text/callout/stamp/fill/selection | Controls observed | Missing | Planned |
| Crop/resize/zoom/styles/redaction/effects | Resize/zoom/effects controls observed | Missing | Planned |
| Recording/audio/video export | Metadata/menu declarations only | Missing | Planned |
| Scrolling/panoramic capture | Requirement; reference untested | Missing | Host-specific investigation planned |
| Cloud/native sharing/drag-drop | Share controls observed | Missing | Planned |
| Signing/notarization/installer | Not investigated | Ad-hoc development app | Release signing blocked by credentials |
