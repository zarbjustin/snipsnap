import AppKit
import SwiftUI
import UniformTypeIdentifiers
import Vision

struct Mark: Codable, Equatable {
    var kind: String
    var x1: Double; var y1: Double; var x2: Double; var y2: Double
    var width: UInt32 = 4
    var color: [UInt8] = [242, 65, 65, 255]
}
struct EditDocument: Codable { var version = 1; var annotations: [Mark] }

@MainActor final class Studio: ObservableObject {
    @Published var image: NSImage?
    @Published var marks: [Mark] = []
    @Published var redoMarks: [Mark] = []
    @Published var tool = "arrow"
    @Published var draft: Mark?
    @Published var busy = false
    @Published var status = "Snip it. Snap it. Done."
    @Published var error: String?
    @Published var ocrText: String?
    var source: URL?
    let directory: URL
    init() {
        directory = FileManager.default.temporaryDirectory.appendingPathComponent("SnipSnap-\(UUID().uuidString)")
        do { try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true) }
        catch { self.error = error.localizedDescription }
    }
    deinit { try? FileManager.default.removeItem(at: directory) }
    nonisolated static func core(_ arguments: [String]) throws -> String {
        guard let executable = Bundle.main.url(forAuxiliaryExecutable: "snipsnap-core") else {
            throw NSError(domain: "SnipSnap", code: 1, userInfo: [NSLocalizedDescriptionKey: "The image engine is missing. Rebuild SnipSnap."])
        }
        let process = Process(); process.executableURL = executable; process.arguments = arguments
        let pipe = Pipe(); process.standardError = pipe; process.standardOutput = FileHandle.nullDevice
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        let detail = String(decoding: data, as: UTF8.self)
        guard process.terminationStatus == 0 else {
            throw NSError(domain: "SnipSnap", code: Int(process.terminationStatus), userInfo: [NSLocalizedDescriptionKey: detail])
        }
        return detail
    }
    func perform(_ action: @escaping @Sendable () throws -> URL, completion: @escaping (URL) -> Void) {
        busy = true
        Task {
            do {
                let url = try await Task.detached(priority: .userInitiated) { try action() }.value
                completion(url)
            } catch { self.error = error.localizedDescription }
            busy = false
        }
    }
    func capture(_ mode: String) {
        guard !busy else { return }
        let destination = directory.appendingPathComponent("\(UUID().uuidString).png")
        // Leave the display before the system picker begins.
        NSApp.hide(nil)
        perform({
            Thread.sleep(forTimeInterval: 0.25)
            _ = try Self.core(["capture", mode, destination.path]); return destination
        }) { url in self.load(url); NSApp.unhide(nil); NSApp.activate(ignoringOtherApps: true) }
        Task {
            while busy { try? await Task.sleep(for: .milliseconds(100)) }
            NSApp.unhide(nil); NSApp.activate(ignoringOtherApps: true)
        }
    }
    func load(_ url: URL) {
        guard let image = NSImage(contentsOf: url), let bitmap = NSBitmapImageRep(data: (try? Data(contentsOf: url)) ?? Data()) else {
            error = "This image could not be opened."; return
        }
        image.size = NSSize(width: bitmap.pixelsWide, height: bitmap.pixelsHigh)
        self.image = image; source = url; marks = []; redoMarks = []
        status = "\(bitmap.pixelsWide) × \(bitmap.pixelsHigh) pixels"
    }
    func openImage() {
        let panel = NSOpenPanel(); panel.allowedContentTypes = [.png, .jpeg]
        if panel.runModal() == .OK, let url = panel.url {
            let local = directory.appendingPathComponent(UUID().uuidString + "." + url.pathExtension)
            do { try FileManager.default.copyItem(at: url, to: local); load(local) }
            catch { self.error = error.localizedDescription }
        }
    }
    func append(_ mark: Mark) { marks.append(mark); redoMarks = [] }
    func undo() { if let m = marks.popLast() { redoMarks.append(m) } }
    func redo() { if let m = redoMarks.popLast() { marks.append(m) } }
    func rendered(_ output: URL, copy: Bool = false) {
        guard let source else { return }
        do {
            let doc = directory.appendingPathComponent(UUID().uuidString + ".json")
            try JSONEncoder().encode(EditDocument(annotations: marks)).write(to: doc, options: .atomic)
            perform({ _ = try Self.core(["render", source.path, doc.path, output.path]); return output }) { url in
                if copy, let image = NSImage(contentsOf: url) {
                    NSPasteboard.general.clearContents(); NSPasteboard.general.writeObjects([image])
                    self.status = "Copied to clipboard"
                } else { self.status = "Saved \(url.lastPathComponent)" }
            }
        } catch { self.error = error.localizedDescription }
    }
    func export() {
        let panel = NSSavePanel(); panel.allowedContentTypes = [.png]; panel.nameFieldStringValue = "SnipSnap.png"
        if panel.runModal() == .OK, let url = panel.url { rendered(url) }
    }
    func copy() { rendered(directory.appendingPathComponent(UUID().uuidString + ".png"), copy: true) }
    func recognize() {
        guard let source else { return }; busy = true
        Task {
            do {
                let text = try await Task.detached(priority: .userInitiated) {
                    let request = VNRecognizeTextRequest(); request.recognitionLevel = .accurate
                    try VNImageRequestHandler(url: source).perform([request])
                    return (request.results ?? []).compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                }.value
                ocrText = text.isEmpty ? "No text found in this image." : text
            } catch { self.error = error.localizedDescription }
            busy = false
        }
    }
}

struct Editor: View {
    @ObservedObject var studio: Studio
    var body: some View {
        GeometryReader { geometry in
            if let image = studio.image {
                let scale = min(geometry.size.width / image.size.width, geometry.size.height / image.size.height)
                let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
                ZStack(alignment: .topLeading) {
                    Image(nsImage: image).resizable().frame(width: size.width, height: size.height)
                    Canvas { context, _ in
                        for m in studio.marks + (studio.draft.map { [$0] } ?? []) {
                            var path = Path()
                            let p = CGPoint(x: m.x1 * scale, y: m.y1 * scale)
                            let q = CGPoint(x: m.x2 * scale, y: m.y2 * scale)
                            if m.kind == "rectangle" {
                                path.addRect(CGRect(x: min(p.x,q.x), y: min(p.y,q.y), width: abs(q.x-p.x), height: abs(q.y-p.y)))
                            } else {
                                path.move(to: p); path.addLine(to: q)
                                if m.kind == "arrow" {
                                    let angle = atan2(q.y-p.y,q.x-p.x); let length = Double(m.width * 4 + 8) * scale
                                    for offset in [-0.5, 0.5] {
                                        path.move(to: q); path.addLine(to: CGPoint(x: q.x-length*cos(angle+offset), y: q.y-length*sin(angle+offset)))
                                    }
                                }
                            }
                            context.stroke(path, with: .color(Color(red: 242/255, green: 65/255, blue: 65/255)), style: StrokeStyle(lineWidth: Double(m.width)*scale, lineCap: .round, lineJoin: .round))
                        }
                    }.frame(width: size.width, height: size.height)
                    .contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 1).onChanged { value in
                        studio.draft = Mark(kind: studio.tool, x1: value.startLocation.x/scale, y1: value.startLocation.y/scale,
                                     x2: min(max(value.location.x,0),size.width)/scale, y2: min(max(value.location.y,0),size.height)/scale)
                    }.onEnded { _ in if let draft = studio.draft { studio.append(draft) }; studio.draft = nil })
                }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "scissors").font(.system(size: 52)).foregroundStyle(.tint)
                    Text("A little snip. A big idea.").font(.title)
                    Text("Capture your screen or open an image, then make your point.").foregroundStyle(.secondary)
                    HStack { Button("Capture Region") { studio.capture("region") }; Button("Open Image…") { studio.openImage() } }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }.padding(24).background(.quaternary.opacity(0.4))
    }
}

@main struct SnipSnap: App {
    @StateObject private var studio = Studio()
    var body: some Scene {
        WindowGroup("SnipSnap") {
            VStack(spacing: 0) {
                Editor(studio: studio)
                HStack { Text(studio.status); Spacer(); if studio.busy { ProgressView().controlSize(.small) } }
                    .font(.caption).padding(10)
            }.frame(minWidth: 800, minHeight: 550)
            .toolbar {
                ToolbarItemGroup {
                    Menu { Button("Region") { studio.capture("region") }; Button("Window") { studio.capture("window") }; Button("Main Display") { studio.capture("screen") } } label: { Label("Capture", systemImage: "camera") }
                    Button { studio.openImage() } label: { Label("Open", systemImage: "folder") }
                    Picker("Annotation", selection: $studio.tool) { Text("Arrow").tag("arrow"); Text("Rectangle").tag("rectangle"); Text("Line").tag("line") }.frame(width: 160)
                    Button { studio.undo() } label: { Label("Undo", systemImage: "arrow.uturn.backward") }.disabled(studio.marks.isEmpty)
                    Button { studio.redo() } label: { Label("Redo", systemImage: "arrow.uturn.forward") }.disabled(studio.redoMarks.isEmpty)
                    Button("Extract Text") { studio.recognize() }.disabled(studio.source == nil)
                    Button { studio.copy() } label: { Label("Copy", systemImage: "doc.on.doc") }.disabled(studio.source == nil)
                    Button("Export PNG…") { studio.export() }.disabled(studio.source == nil)
                }
            }.disabled(studio.busy)
            .alert("SnipSnap", isPresented: Binding(get: { studio.error != nil }, set: { if !$0 { studio.error = nil } })) {
                Button("OK") { studio.error = nil }
                Button("Screen Recording Settings") { NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")!) }
            } message: { Text(studio.error ?? "") }
            .sheet(isPresented: Binding(get: { studio.ocrText != nil }, set: { if !$0 { studio.ocrText = nil } })) {
                VStack { Text("Text from your capture").font(.headline); TextEditor(text: Binding(get: { studio.ocrText ?? "" }, set: { studio.ocrText = $0 })).frame(width: 500,height: 300)
                    HStack { Button("Copy Text") { NSPasteboard.general.clearContents(); NSPasteboard.general.setString(studio.ocrText ?? "", forType: .string) }; Button("Done") { studio.ocrText = nil } }
                }.padding()
            }
        }.commands {
            CommandGroup(after: .newItem) {
                Button("Capture Region") { studio.capture("region") }.keyboardShortcut("2", modifiers: [.command,.shift]).disabled(studio.busy)
                Button("Open Image…") { studio.openImage() }.keyboardShortcut("o").disabled(studio.busy)
                Button("Export PNG…") { studio.export() }.keyboardShortcut("s").disabled(studio.source == nil || studio.busy)
            }
            CommandGroup(replacing: .undoRedo) {
                Button("Undo Annotation") { studio.undo() }.keyboardShortcut("z").disabled(studio.marks.isEmpty || studio.busy)
                Button("Redo Annotation") { studio.redo() }.keyboardShortcut("z", modifiers: [.command,.shift]).disabled(studio.redoMarks.isEmpty || studio.busy)
            }
        }
        MenuBarExtra("SnipSnap", systemImage: "scissors") {
            Button("Capture Region") { studio.capture("region") }.disabled(studio.busy)
            Button("Capture Window") { studio.capture("window") }.disabled(studio.busy)
            Button("Capture Main Display") { studio.capture("screen") }.disabled(studio.busy)
            Divider(); Button("Show SnipSnap") { NSApp.activate(ignoringOtherApps: true) }; Button("Quit") { NSApp.terminate(nil) }
        }
    }
}
