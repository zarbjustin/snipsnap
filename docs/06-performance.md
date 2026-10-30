# Performance baseline

No Snagit comparison or speedup claim has been made. On this arm64 Mac, initial Rust tests compiled in 7.54 s; first optimized core build completed in 8.44 s. These are build timings, not application latency benchmarks.

Record cold/warm launch, picker launch, selection-to-preview, peak RSS, idle CPU, export latency and annotation responsiveness using synthetic 640×400, 4K and large-image cases. Capture API timing must exclude human selection time. Run repeated samples and report distribution, hardware, OS, scale and build profile. Recording needs frame-drop/audio-drift and sustained-memory measurements before release.

Current known costs: one process and source decode per export; Swift preview caches NSImage; the core clips each annotation's scan bounds to image dimensions. Large diagonal strokes can scan a large box; benchmark before adding many freehand segments. Avoid repeated encoding in a future persistent service only if measurement warrants it.
