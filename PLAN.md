# Delivery plan

1. Establish environment, bounded reference evidence and an independent architecture.
2. Deliver the screenshot vertical slice: capture → native preview → editable marks → PNG → clipboard, with reproducible tests and a development app bundle.
3. Harden capture: ScreenCaptureKit backend, display selection, global hotkey, permission onboarding, cancellation, multi-display/Retina matrix.
4. Grow the document editor: project persistence, editable selection, crop/resize, text, ellipses, freehand, blur/redaction, style controls, zoom.
5. Add capture history/search in SQLite and searchable OCR metadata.
6. Implement ScreenCaptureKit recording with AVFoundation encoding, audio permissions, controls and measured stability.
7. Investigate scrolling capture per supported host; add composition, templates and native sharing.
8. Profile, independently review, bug bash, sign/notarize and package a distributable release.

Each phase must update FEATURE_PARITY.md, TEST_RESULTS.md and KNOWN_ISSUES.md. A compiled control is not proof of a working workflow. No universal scrolling, recording, performance or parity claims without evidence.
