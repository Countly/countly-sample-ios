// AppLog.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// Shared, in-app log so async SDK results (RC downloads, device ID, content
/// callbacks, errors) are visible without the Xcode console.
///
/// The SDK's own internal log is piped in here too, through `SDKLogRelay`, so the
/// pane shows both what the sample asked for and what the SDK made of it.
final class AppLog: ObservableObject {
    static let shared = AppLog()

    @Published var lines: [String] = []
    @Published var latest: String = "Ready"

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()

    func log(_ msg: String) {
        stamp("\u{25B6} \(msg)", latest: msg)
    }

    /// A line the SDK itself emitted, already carrying its own level prefix.
    ///
    /// Not echoed to the console: the SDK has already printed it there, and
    /// printing it twice makes the console harder to read than no pane at all.
    func sdk(_ msg: String) {
        stamp("   \(msg)", latest: nil, echo: false)
    }

    func clear() {
        DispatchQueue.main.async {
            self.lines.removeAll()
            self.latest = "Cleared"
        }
    }

    var transcript: String {
        lines.reversed().joined(separator: "\n")
    }

    private func stamp(_ line: String, latest: String?, echo: Bool = true) {
        let stamped = "\(formatter.string(from: Date())) \(line)"
        DispatchQueue.main.async {
            if let latest { self.latest = latest }
            self.lines.insert(stamped, at: 0)
            if self.lines.count > 500 { self.lines.removeLast() }
            if echo { NSLog("[Sample] %@", line) }
        }
    }
}

/// Hands every internal SDK log line to the pane.
///
/// Held by the sample rather than the SDK: `CountlyConfig.loggerDelegate` is weak,
/// so a delegate nobody else retains stops receiving lines the moment init
/// returns.
final class SDKLogRelay: CountlyLoggerDelegate {
    static let shared = SDKLogRelay()

    func internalLog(_ log: String, level: CountlyLogLevel) {
        AppLog.shared.sdk(log)
    }
}

/// A button that runs an SDK action and logs it. The label doubles as the log message.
struct ActionButton: View {
    let title: String
    let action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(title) {
            AppLog.shared.log(title)
            action()
        }
    }
}

/// The log pane that sits under every screen.
///
/// A pane rather than the iOS sample's sheet: a desktop window has the room, and
/// the point of most of these screens is watching what the SDK says back while
/// pressing the next button.
struct LogPane: View {
    @ObservedObject private var log = AppLog.shared
    @AppStorage("logPaneExpanded") private var expanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Button {
                    expanded.toggle()
                } label: {
                    Image(systemName: expanded ? "chevron.down" : "chevron.up")
                }
                .buttonStyle(.borderless)
                .help(expanded ? "Collapse the log" : "Expand the log")

                Text(log.latest)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)

                Spacer()

                Button("Copy") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(log.transcript, forType: .string)
                }
                .buttonStyle(.borderless)
                .font(.caption)

                Button("Clear") { log.clear() }
                    .buttonStyle(.borderless)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)

            if expanded {
                Divider()
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 1) {
                        ForEach(Array(log.lines.enumerated()), id: \.offset) { _, line in
                            Text(line)
                                .font(.system(size: 11, design: .monospaced))
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                }
                .frame(height: 180)
            }
        }
        .background(.thinMaterial)
    }
}
