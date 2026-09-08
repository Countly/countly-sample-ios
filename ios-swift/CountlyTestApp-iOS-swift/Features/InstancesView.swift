// InstancesView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// Starts and drives a second SDK instance, configured here rather than in code.
///
/// The point of a second instance is reporting to somewhere the default instance
/// does not, so the name, app key and server are the things worth changing.
struct InstancesView: View {

    @AppStorage("secondInstanceName") private var name = "secondary"
    @AppStorage("secondInstanceAppKey") private var appKey = "YOUR_SECOND_APP_KEY"
    @AppStorage("secondInstanceHost") private var host = "https://your.server.ly"

    @State private var eventKey = "event-on-second-instance"

    /// Resolved on demand: the name is editable, so caching the handle would leave
    /// the buttons acting on whichever instance was named when the screen opened.
    private var second: CountlyInstance { Countly.instance(named: trimmedName) }
    private var trimmedName: String { name.trimmingCharacters(in: .whitespaces) }

    var body: some View {
        Form {
            Section {
                LabeledField("Instance name", text: $name)
                LabeledField("App key", text: $appKey)
                LabeledField("Server URL", text: $host, keyboard: .URL)
            } header: {
                Text("Second instance")
            } footer: {
                Text("Each instance owns its storage, device ID, request queue and consent state, keyed by this name. A natural choice is the app key, which gives one isolated instance per dashboard application.")
            }

            Section {
                Button("Start") { start() }
                Button("Record an Event") {
                    guard requireStarted() else { return }
                    second.events.recordEvent(eventKey)
                    AppLog.shared.log("recorded '\(eventKey)' on '\(trimmedName)'")
                }
                LabeledField("Event key", text: $eventKey)
                Button("Record a View") {
                    guard requireStarted() else { return }
                    _ = second.views.startView("SecondInstanceView")
                    AppLog.shared.log("started a view on '\(trimmedName)'")
                }
                Button("Print its Device ID") {
                    guard requireStarted() else { return }
                    AppLog.shared.log("'\(trimmedName)' device ID: \(second.deviceID.current ?? "none")")
                }
            } header: {
                Text("Drive it")
            } footer: {
                Text("Nothing recorded here reaches the default instance, and nothing recorded on the main screens reaches this one.")
            }

            Section("Registry") {
                Button("List Instances") {
                    let names = Countly.listInstances()
                    AppLog.shared.log(names.isEmpty ? "no named instances" : names.joined(separator: ", "))
                }
                Button("Look this Instance up") {
                    AppLog.shared.log("'\(trimmedName)' exists: \(Countly.getInstance(named: trimmedName) != nil)")
                }
            }

            Section {
                Button("Halt it", role: .destructive) {
                    second.halt()
                    AppLog.shared.log("halted '\(trimmedName)', its storage is untouched")
                }
                Button("Halt it and Clear its Storage", role: .destructive) {
                    second.halt(clearStorage: true)
                    AppLog.shared.log("halted '\(trimmedName)' and erased what it stored")
                }
                Button("Halt Every Instance", role: .destructive) {
                    Countly.haltAllInstances()
                    AppLog.shared.log("halted every instance")
                }
            } header: {
                Text("Shutting down")
            } footer: {
                Text("Halting stops an instance but leaves what it wrote on disk. Clearing storage erases every key it owns, which is what a data deletion request needs.")
            }
        }
    }

    private func start() {
        guard !trimmedName.isEmpty else { return AppLog.shared.log("an instance needs a name") }
        guard !appKey.isEmpty, !host.isEmpty else { return AppLog.shared.log("an instance needs an app key and a server URL") }

        guard !second.isStarted else { return AppLog.shared.log("'\(trimmedName)' is already running") }

        let config = CountlyConfig()
        config.appKey = appKey
        config.host = host
        config.enableDebug = true
        config.internalLogLevel = .debug

        second.start(with: config)
        AppLog.shared.log("started '\(trimmedName)' against \(host)")
    }

    private func requireStarted() -> Bool {
        guard second.isStarted else {
            AppLog.shared.log("'\(trimmedName)' is not running, start it first")
            return false
        }
        return true
    }
}
