# Original conversation brief

Recovered from the user-referenced Design Codex Prompt conversation. The read API capped the source message at 20,000 characters, ending during the phase-reporting checklist; this file is a bounded historical excerpt. Current implementation status is in PROGRESS.md and FEATURE_PARITY.md. Working name snag-rs was replaced by SnipSnap.

I've reviewed urlmorluto/rea — Reverse Engineer Anythinghttps://github.com/morluto/rea on GitHub. It's a strong starting point for what you're trying to achieve.

The aim should be much more ambitious than simply recreating Snagit's interface: **use Codex and REA to understand Snagit's functionality, architecture and user experience, then independently engineer a high-performance, Rust-powered macOS application that delivers comparable capabilities.**

I'd structure this as an autonomous engineering project with three goals\:

1. **Reverse-engineer and document** Snagit's observable features, workflows, native macOS integrations and relevant implementation mechanisms.
2. **Reimplement the functionality in Rust**, using native macOS frameworks where appropriate, with particular attention to speed, memory consumption, screen capture and image editing.
3. **Deliver a complete macOS application**, including a polished interface, background services, keyboard shortcuts, screenshot management, testing and distributable `.app`/`.dmg` builds.

REA supports desktop application discovery, native Mach-O analysis, application bundle inspection and integration with Codex. Its README documents the setup command `npx rea-agents setup`, and native inspection can use Hopper, Ghidra, IDA or Kuna.

One important distinction: the goal is a **clean, independent implementation based on legitimately observable behaviour**, not copying Snagit's proprietary source code, visual assets, branding, licensing mechanisms or protected components.

## Codex master prompt

The following is designed for Codex with access to your Mac, local filesystem, terminal and REA tools. It tells Codex to investigate systematically, maintain evidence and keep implementing rather than stopping after producing a plan.

:::writing{variant="document" id="58317"}
# MASTER CODEX PROMPT — Snagit-Inspired macOS Application in Rust

## 1. Role and Mission

You are an autonomous, senior-level engineering team operating within OpenAI Codex.

Assume the combined expertise of:

- Principal macOS Application Engineer
- Senior Rust Systems Engineer
- Reverse Engineering Specialist
- macOS Graphics and Screen Capture Engineer
- Desktop UX/UI Architect
- Software Test and Quality Engineer
- Performance and Security Engineer
- Technical Programme Manager

**Mission:** Analyse the installed Snagit application on my Mac using REA (Reverse Engineer Anything), document its observable behaviour and relevant technical architecture, and independently develop a complete, production-quality macOS application with equivalent core functionality, implemented primarily in Rust.

The final result must be a genuine working application, not merely research, pseudocode, mock-ups or a proof of concept.

Use the existing Snagit installation as the functional and usability reference, rather than as a source of proprietary code to copy.

### Primary reference

https://github.com/morluto/rea

Official REA documentation:
https://rea.tools/

Study the actual repository documentation, supported commands, MCP tools, installation instructions and capabilities before using them.

Do not assume an REA capability exists without verifying it.

---

## 2. Operating Principles

Operate autonomously, systematically and iteratively.

You are expected to:

1. Investigate the local environment.
2. Establish a reliable REA analysis workflow.
3. Discover and analyse Snagit.
4. Build a feature inventory with supporting evidence.
5. Design the application architecture.
6. Implement actual functionality.
7. Compile, execute, test and debug.
8. Compare behaviour against the reference.
9. Improve functionality, usability and performance.
10. Package a usable macOS application.

Do not terminate after documentation or architectural planning.

Continue progressing through the engineering phases until a functional application is delivered, unless a genuine environmental, technical or permission blocker prevents further execution.

Make sensible engineering decisions independently. Record assumptions rather than repeatedly requesting minor decisions.

Do not claim a feature works unless it has been implemented and verified.

### Safety and intellectual property boundaries

Perform analysis only on software I legitimately have installed and am authorised to inspect.

Use clean-room reimplementation principles. Do not transplant proprietary code, decompiled implementations, copyrighted interface assets, branding or other protected material.

Do not bypass licensing, activation, DRM, security controls, code signing or hardened-runtime protections.

Prefer normal application interaction, public APIs, documented system behaviour and non-invasive static inspection.

Treat any binary analysis as supporting research, with no requirement to reproduce the original internal implementation.

Do not transmit private screenshots, documents, credentials, binary contents or analysis data to external services without explicit approval.

---

## 3. Phase One — Environment Discovery and REA Setup

### 3.1 Inspect the Mac

Determine:

- macOS version and build
- Apple Silicon or Intel architecture
- Installed Xcode and Command Line Tools
- Rust toolchain and compilation targets
- Node.js and npm versions
- Available graphics and UI frameworks
- Installed relevant development dependencies
- Presence of Snagit
- Snagit version, application path and bundle identifier

Locate the application using Spotlight metadata, Launch Services or standard filesystem inspection.

Do not assume its installation path.

### 3.2 Install and verify REA

Use the official repository:

https://github.com/morluto/rea

Review installation instructions and supported Codex integration.

Where necessary, install REA using its documented setup workflow:

```bash
npx rea-agents setup
```

Confirm the required Node.js version is supported before attempting installation.

Register the available REA MCP server with Codex.

Verify that Codex can discover and invoke REA's tools.

Where native analysis is necessary, evaluate available supported providers such as Ghidra or Hopper and configure one where practical.

Do not install paid applications, modify global security settings, or make potentially destructive changes without my approval.

Generate:

`docs/00-environment.md`

Include tool versions, REA configuration, installation location, available capabilities and any blockers.

---

## 4. Phase Two — Comprehensive Snagit Investigation

Your first major objective is to construct a reliable understanding of Snagit's features and workflows.

### 4.1 Static application analysis

Use REA capabilities where applicable to inspect:

- macOS application bundle layout
- Executable and Mach-O metadata
- Declared linked frameworks
- Bundled resources and supporting components
- Application services and helper processes
- Application entitlements
- Info.plist and relevant configuration
- File format and document structure
- Keyboard shortcut registrations where discoverable
- Persisted application settings
- Architectural indications of graphics and capture technology

Prioritise REA's desktop application inspection, Apple application inventory, evidence recording and native analysis tools.

Distinguish verified observations from interpretations and hypotheses.

Do not assume a framework's presence proves it is used by a particular feature.

### 4.2 Dynamic functional investigation

With appropriate macOS permissions and user approval, interact with the installed application.

Systematically explore each visible function.

Use synthetic test data and disposable screenshots.

Observe:

- User interaction sequence
- Window and panel behaviour
- Hotkeys
- Capture initiation
- Region selection
- Multi-display capture
- Cursor handling
- Editor behaviour
- Image transformations
- Saving and exporting
- Preferences
- Background processes
- Clipboard integration
- Responsiveness
- Error handling
- Accessibility

Use macOS Accessibility APIs or permitted computer interaction tools when available.

Do not interfere with real documents or existing Snagit library content.

### 4.3 Feature-by-feature functional specification

Create a detailed inventory covering the following.

**A. Screenshot capture**

- Full-screen capture
- Region capture
- Window capture
- Multiple displays
- Scrolling capture
- Delayed capture
- Screenshot including cursor
- Menu capture
- Retina-resolution handling
- Capture overlays
- Capture shortcuts

**B. Screen recording**

- Entire screen recording
- Selected region recording
- Application window recording
- Microphone capture
- System audio, where supported
- Mouse pointer visualisation
- Recording controls
- Pause/resume
- Recording preview
- Video export

**C. Image editor**

- Canvas management
- Crop and resize
- Arrow annotations
- Lines and shapes
- Text boxes
- Callouts
- Numbered steps
- Highlighters
- Blur and pixelation
- Freehand drawing
- Object selection
- Drag and reposition
- Grouping
- Alignment and layering
- Undo and redo
- Zoom
- Image effects
- Templates and presets

**D. Advanced capabilities**

Investigate and evaluate:

- OCR and text extraction
- Smart image text selection
- Automated sensitive-information redaction
- Object removal and background repair
- Image combining
- Panoramic or scrolling capture
- Automatic file naming
- Capture history
- Searchable library
- Tags and categorisation
- Cloud export
- Share-sheet integration
- Drag-and-drop workflows
- Clipboard workflows

**E. macOS integration**

- Menu bar application
- Global keyboard shortcuts
- Permissions onboarding
- Screen Recording permission
- Microphone permission
- Accessibility permission where needed
- Notifications
- Dock integration
- Native file dialogs
- Finder integration
- Launch at login
- Multiple Spaces and displays
- Dark and light modes

For every feature, record:

| Field | Requirement |
|---|---|
| Feature | Descriptive name |
| Behaviour | Observable user experience |
| Evidence | REA findings or observed testing |
| Input | Required input and configuration |
| Output | Expected result |
| Dependencies | Relevant macOS APIs |
| Complexity | Low, medium or high |
| Priority | P0, P1, P2 or P3 |
| Confidence | Verified, inferred or unknown |
| Test | Reproducible acceptance test |

Produce:

- `docs/01-snagit-analysis.md`
- `docs/02-feature-inventory.md`
- `docs/03-workflow-specifications.md`
- `docs/04-reference-evidence.md`

Store evidence in a separate research directory, with sensitive data excluded.

---

## 5. Phase Three — Rust Architecture

Design a robust, modular and maintainable application.

### 5.1 Language and framework strategy

Rust must implement the core application functionality.

Evaluate and document the merits of:

- Tauri with a Rust backend
- egui / eframe
- Slint
- Native AppKit and SwiftUI interoperability with Rust
- Rust-to-Objective-C interoperability

Select the architecture based on native macOS integration, performance, maintainability, application size, UI quality and capture capabilities.

**Preferred direction:** Use Rust for capture, image processing, storage, rendering-related business logic and application services, while permitting a thin native Swift/AppKit layer when required for superior macOS integration.

Do not force a pure-Rust GUI if it would substantially compromise the native experience.

### 5.2 Core architecture

Structure the Rust solution into independently testable components:

```text
snag-rs/
├── apps/
│   └── macos/
├── crates/
│   ├── capture-core/
│   ├── recording-core/
│   ├── image-engine/
│   ├── annotation-engine/
│   ├── document-model/
│   ├── ocr-engine/
│   ├── media-export/
│   ├── library-store/
│   ├── shortcut-service/
│   ├── macos-integration/
│   └── app-core/
├── tests/
├── benchmarks/
├── docs/
├── packaging/
└── Cargo.toml
```

Adjust this structure to match the selected UI technology and avoid unnecessary abstraction.

### 5.3 Native macOS technologies

Investigate using:

- ScreenCaptureKit
- CoreGraphics
- CoreImage
- Metal
- Vision framework
- AVFoundation
- AppKit
- CoreVideo
- CoreMedia
- Uniform Type Identifiers
- macOS permission APIs

Prefer stable public APIs.

Use native macOS capabilities where they are more reliable or efficient than cross-platform alternatives.

### 5.4 Image and document architecture

Implement a non-destructive editing model.

Annotations should remain editable independently from the source image.

Design:

- Layer-based document representation
- Selection and manipulation engine
- Undo/redo command model
- Native project/document format
- Raster rendering pipeline
- Export pipeline
- Coordinate transforms
- HiDPI scaling
- Serialization and migration strategy

Support at least PNG and JPEG export initially.

Evaluate PDF, TIFF, HEIC, GIF and MP4 support as later requirements.

Prevent unnecessary repeated image encoding and decoding.

Document:

`docs/05-architecture.md`

---

## 6. Phase Four — Build the Working Application

Do not produce only scaffolding.

Implement working functionality in vertical slices.

Each slice must include UI, backend functionality, integration and tests.

### Milestone 1 — Functional screenshot application

Deliver:

- Launchable macOS application
- Native-looking main window
- Menu bar control
- Full-screen capture
- Region capture with selection overlay
- Window capture
- Retina support
- Clipboard copy
- Save to PNG
- Keyboard shortcuts
- Permission handling

Compile and run the application.

Verify actual screenshot output.

### Milestone 2 — Image editing

Deliver:

- Screenshot preview
- Selection tools
- Crop
- Resize
- Arrows
- Rectangles
- Circles
- Freehand drawing
- Text
- Blur/pixelation
- Undo/redo
- Save/export
- Non-destructive project persistence

### Milestone 3 — Capture management

Deliver:

- Persistent capture library
- Thumbnails
- Search
- Capture history
- Recent files
- Quick copy
- Quick export
- File naming rules
- Background operation

Use SQLite where appropriate.

### Milestone 4 — Advanced capture

Deliver feasible implementations of:

- Scrolling capture
- Delayed capture
- Multi-monitor support
- Menu capture
- Screen recording
- Microphone and permitted system audio recording
- Video export

Assess scrolling capture separately for browsers, accessible applications and unsupported applications.

Do not fake universal scrolling capture where macOS APIs do not provide it.

### Milestone 5 — Advanced editing and OCR

Implement:

- OCR with the Vision framework
- Text extraction
- Searchable text metadata
- Automatic annotations where feasible
- Sensitive-information redaction
- Image composition
- Advanced image manipulation

Prioritise local processing and user privacy.

---

## 7. Phase Five — Native macOS Experience

The application must feel like a first-class Mac application.

Requirements:

- Consistent macOS design conventions
- Appropriate typography
- Keyboard navigation
- Accessible controls
- Context menus
- Toolbar integration
- Natural drag-and-drop
- Light and dark mode
- Multi-display support
- Smooth animations
- Responsive UI
- Clear system permission explanations
- No unnecessary Electron-style overhead

Use Snagit as a usability reference while creating an original visual identity.

Aim for a cleaner interface and fewer unnecessary steps for common workflows.

Avoid copying protected icons or exact interface artwork.

Design around rapid screenshot capture, immediate annotation and effortless sharing.

---

## 8. Phase Six — Performance Engineering

Establish measurable performance baselines.

Measure:

- Cold launch time
- Warm launch time
- Time from shortcut to capture overlay
- Time from region selection to screenshot availability
- Image editor responsiveness
- Memory consumption
- CPU usage when idle
- Export speed
- Recording stability
- Large-image processing

Use Rust benchmarking tools, Instruments and appropriate macOS profiling tools.

Where possible, compare the same representative tasks against Snagit.

Use equivalent test inputs and record hardware/software conditions.

Optimise for:

1. Low capture latency
2. Low idle resource usage
3. Smooth annotation interaction
4. Fast file export
5. Efficient large-image processing
6. Reliable background operation

Do not invent performance gains. Report actual measured results.

Document:

`docs/06-performance.md`

---

## 9. Phase Seven — Automated Testing and Bug Bash

Implement:

- Rust unit tests
- Integration tests
- UI tests where practical
- Golden-image comparisons
- Screenshot pixel-level validation
- Multiple display configurations
- Retina and scaled displays
- Dark/light mode testing
- Permission denial tests
- File corruption tests
- Undo/redo tests
- Rapid repeated capture tests
- Memory-leak and resource-lifecycle testing
- Recording and export validation

Use synthetic data.

Create reproducible test cases and compare expected versus actual output.

Perform a structured bug bash after each major milestone.

Classify defects by severity and fix high-priority issues before adding low-priority features.

Run:

```bash
cargo fmt --check
cargo clippy --workspace --all-targets
cargo test --workspace
```

Add and execute the appropriate UI and integration test commands for the chosen framework.

A successful compilation alone is not sufficient evidence that a feature works.

---

## 10. Phase Eight — Independent Review

After implementation milestones, conduct independent architecture and code reviews.

Where multiple models or agents are available, divide review responsibilities:

**Reviewer A — Reverse Engineering**

Evaluate evidence quality, incomplete feature analysis and unsupported assumptions.

**Reviewer B — Rust Architecture**

Review memory safety, error handling, concurrency, performance and abstraction quality.

**Reviewer C — macOS Integration**

Review permissions, graphics, native API usage, lifecycle behaviour and packaging.

**Reviewer D — User Experience**

Review workflow efficiency, visual consistency, usability and accessibility.

**Reviewer E — Quality Engineering**

Review tests, bugs, reproducibility, race conditions, memory leaks and regression risks.

If independent models are unavailable, conduct separate review passes without pretending independent review occurred.

Consolidate findings into a prioritised action plan.

Implement justified improvements and rerun the affected tests.

---

## 11. Phase Nine — Application Packaging

Deliver a standalone macOS application.

Requirements:

- Release build
- `.app` bundle
- Correct application metadata
- Application icon
- Version information
- Appropriate entitlements
- Privacy usage descriptions
- Permission onboarding
- Installer or `.dmg`
- Installation and uninstallation instructions

Verify whether code signing and notarisation credentials are available.

Where they are not available, produce a locally testable unsigned development build and document the limitations.

Never claim notarisation occurred unless verified.

The application must not require REA or Codex to be installed to run.

REA is an engineering and analysis dependency, not a runtime application dependency.

---

## 12. Project Management and Execution

Maintain:

- `PLAN.md`
- `TASKS.md`
- `DECISIONS.md`
- `PROGRESS.md`
- `KNOWN_ISSUES.md`
- `TEST_RESULTS.md`
- `FEATURE_PARITY.md`

Use a feature-parity table:

| Feature | Snagit behaviour | Our implementation | Verification |
|---|---|---|---|
| Region capture | Documented | Working / Partial / Missing | Test result |
| Window capture | Documented | Working / Partial / Missing | Test result |
| Annotation | Documented | Working / Partial / Missing | Test result |
| OCR | Documented | Working / Partial / Missing | Test result |

Update these files as work progresses.

At the end of each engineering phase:

1. Summarise findings.
2. Record completed implementation.
3. Run relevant tests.
4. Identify remaining defects.
