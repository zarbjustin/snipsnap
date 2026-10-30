# Review passes

No independent agent/model review was performed. These are separate self-review passes, with limitations retained.

Evidence: confirmed metadata observations are not labelled feature behaviour. Captured user pixels and Snagit recents/assets are excluded from the repository. Bounded source brief is labelled as an excerpt.

Rust correctness: fixed JPEG RGBA export, straight-alpha blending, direct-source overwrite and alias checks, bounded JSON reads, image decode limits and atomic export publication. Added regression coverage for corrupt image rejection and preserving an existing export on failure. Fixed-style opaque UI path remains the only manually exercised annotation colour/style.

macOS integration: validated native build, actual launch, source preview, user-assisted region capture following system privacy approval, local Vision extraction, annotation undo/redo, copy command and native save dialog. Display/window/permission matrix, clipboard destination paste and clean-machine installation remain incomplete.

UX: verified empty-state and editor layout in dark appearance. Native picker interaction needed the user's assistance. Persistent editable projects and an unsaved-work warning are the next high-priority UX work; the README explicitly says to export before quitting.

Release: verified ad-hoc signatures and plist syntax locally. No Developer ID identity or notarization. CI is authored but its remote result must be checked separately; local success is not a CI-success claim. Current release is a development MVP, not production-ready parity.
