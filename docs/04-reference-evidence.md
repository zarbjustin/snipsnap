# Evidence register

| ID | Source | Observation | Confidence / limit |
|---|---|---|---|
| E01 | REA 6.7.0 inspect-plist /Applications/Snagit.app --format json | Bundle/version, declared document types and permissions | Verified declarations only |
| E02 | REA 6.7.0 inspect-macho /Applications/Snagit.app --format json | Architectures and dynamic framework dependencies | Verified metadata; no feature attribution |
| E03 | Native accessibility tree, Snagit editor, 30 Oct 2026 | Editor tools, arrow properties, library/copy/share controls | Visible controls only |
| E04 | Native accessibility tree, Snagit File menu | New/open/save/import/export/print commands | Visible menu only |
| E05 | SnipSnap UI test with synthetic 640×400 PNG | Preview, arrow drawing, native save dialog, exported red arrow | Verified UI and decoded PNG |
| E06 | User-assisted macOS region picker after permission approval | 820×442 screenshot returned to SnipSnap | Verified pixels/preview; capture is local and excluded from publication |

REA evidence IDs: E01 ev_e9932833cd1ff068969a0d4309b9ecb1c87b100d228ef9dcc1029e3fcf234f97; E02 ev_6a56e3f97bddb195de4256b2319fe2e187973eefc2f213ba59ab5996f2272342. Main executable digest reported by REA: f9aaadb51ee4a2b21da9a8c4962686517cd75ecdfb7f8532b4a99ea920b0ef4f.

Raw metadata results and local UI/capture scratch files are retained outside this repository under the task's work directory. Only a minimal authored factual summary is published. No proprietary code, binary, assets, user recents or private screenshots are committed.
