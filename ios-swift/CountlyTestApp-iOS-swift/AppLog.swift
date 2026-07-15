// AppLog.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI
import Countly

/// Shared, in-app log so async SDK results (widget lists, RC downloads, device ID, errors)
/// are visible without the Xcode console.
final class AppLog: ObservableObject {
    static let shared = AppLog()
    @Published var lines: [String] = []
    @Published var latest: String = "Ready"

    func log(_ msg: String) {
        DispatchQueue.main.async {
            self.latest = msg
            self.lines.insert(msg, at: 0)
            if self.lines.count > 200 { self.lines.removeLast() }
            NSLog("[Sample] %@", msg)
        }
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

/// Bottom status banner showing the latest logged line, with a sheet listing recent lines.
struct StatusBanner: View {
    @ObservedObject var log = AppLog.shared
    @State private var showSheet = false
    var body: some View {
        HStack {
            Text(log.latest).font(.caption).lineLimit(1).foregroundStyle(.secondary)
            Spacer()
            Button("Log") { showSheet = true }.font(.caption)
        }
        .padding(.horizontal).padding(.vertical, 6)
        .background(.thinMaterial)
        .sheet(isPresented: $showSheet) {
            NavigationStack {
                List(log.lines, id: \.self) { Text($0).font(.caption.monospaced()) }
                    .navigationTitle("Log")
                    .toolbar { Button("Close") { showSheet = false } }
            }
        }
    }
}
