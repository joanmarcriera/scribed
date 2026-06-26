import SwiftUI
import SeshatCore

/// Native settings window — replaces the Python localhost settings server.
/// Edits a draft Config and applies it to the controller on Save.
struct SettingsView: View {
    let controller: WatcherController

    @State private var draft: Config
    @State private var openAtLogin: Bool
    @State private var conn: (whisperx: Bool?, server: Bool?, local: Bool?) = (nil, nil, nil)
    @State private var saved = false

    private static let models = ["tiny", "base", "small", "medium", "large-v2", "large-v3"]

    init(controller: WatcherController) {
        self.controller = controller
        _draft = State(initialValue: controller.config)
        _openAtLogin = State(initialValue: controller.openAtLogin)
    }

    var body: some View {
        Form {
            Section("Getting started") {
                Text("Seshat watches a folder and turns each new recording into a Markdown note using your own WhisperX + Ollama servers. Fill in the URLs below and press Test connection.")
                    .font(.callout).foregroundStyle(.secondary)
                folderRow("Watches", Config.resolvePath(draft.recordingsDir).path)
                folderRow("Writes notes to", Config.resolvePath(draft.notesDir).path)
                folderRow("Working files", Config.resolvePath(draft.workDir).path)
                Text("These folders are created automatically if they don't exist. Tip: set the watch folder to an iCloud Drive / Google Drive folder so recordings made elsewhere are processed once they finish syncing.")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Section("General") {
                Picker("Watch interval", selection: $draft.watchIntervalSeconds) {
                    ForEach(WatcherController.intervalChoices, id: \.self) { secs in
                        Text(secs % 60 == 0 ? "\(secs / 60)m" : "\(secs)s").tag(secs)
                    }
                }
                TextField("Watch folder", text: $draft.recordingsDir)
                TextField("Notes folder", text: $draft.notesDir)
                TextField("Work folder", text: $draft.workDir)
                TextField("Note owner", text: $draft.noteOwner)
                TextField("Your speaker label", text: $draft.userSpeaker)
                Toggle("Open at login", isOn: $openAtLogin)
                    .onChange(of: openAtLogin) { controller.setOpenAtLogin($0) }
            }

            Section("Transcription (WhisperX)") {
                TextField("WhisperX URL", text: $draft.transcribe.whisperxURL)
                Picker("Model", selection: $draft.transcribe.model) {
                    ForEach(Self.models, id: \.self) { Text($0).tag($0) }
                }
                TextField("Language", text: $draft.transcribe.language)
                Stepper("Number of speakers: \(draft.transcribe.numSpeakers)",
                        value: $draft.transcribe.numSpeakers, in: 1...10)
                Toggle("Diarize (separate speakers)", isOn: $draft.transcribe.diarize)
            }

            Section("Summarisation (Ollama)") {
                Picker("Backend", selection: $draft.summarise.backend) {
                    Text("Server (GPU)").tag("server")
                    Text("Local Mac").tag("local")
                }
                TextField("Server Ollama URL", text: $draft.summarise.server.url)
                TextField("Server model", text: $draft.summarise.server.model)
                TextField("Local Ollama URL", text: $draft.summarise.local.url)
                TextField("Local model", text: $draft.summarise.local.model)
                Toggle("Allow local Ollama fallback (loads this Mac)",
                       isOn: $draft.summarise.allowLocalFallback)
            }

            Section("Connections") {
                HStack(spacing: 16) {
                    dot("WhisperX", conn.whisperx)
                    dot("Server Ollama", conn.server)
                    dot("Local Ollama", conn.local)
                }
                Button("Test connection") {
                    Task {
                        let r = await controller.testConnections(draft)
                        conn = (r.whisperx, r.ollamaServer, r.ollamaLocal)
                    }
                }
            }

            HStack {
                if saved {
                    Text("Saved — applied immediately.").foregroundStyle(.green).font(.callout)
                }
                Spacer()
                Button("Save") {
                    controller.applyConfig(draft)
                    saved = true
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .formStyle(.grouped)
        .frame(width: 520, height: 640)
    }

    private func folderRow(_ label: String, _ path: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label).foregroundStyle(.secondary)
            Spacer()
            Text(path)
                .font(.callout.monospaced())
                .textSelection(.enabled)
                .lineLimit(1).truncationMode(.middle)
        }
    }

    private func dot(_ label: String, _ state: Bool?) -> some View {
        let color: Color = state == nil ? .gray : (state! ? .green : .red)
        return HStack(spacing: 6) {
            Circle().fill(color).frame(width: 9, height: 9)
            Text(label).font(.callout)
        }
    }
}
