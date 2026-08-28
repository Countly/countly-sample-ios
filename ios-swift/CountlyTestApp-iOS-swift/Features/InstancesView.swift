// InstancesView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct InstancesView: View {

    private let secondName = "secondary"
    private var second: CountlyInstance { Countly.instance(named: secondName) }

    var body: some View {
        Form {
            Section {
                ActionButton("Start the Second Instance") {
                    guard !second.isStarted else { return AppLog.shared.log("already running") }
                    let config = CountlyConfig()
                    config.appKey = "SECOND_APP_KEY"
                    config.host = "https://your.server.ly"
                    config.enableDebug = true
                    second.start(with: config)
                    AppLog.shared.log("second instance started")
                }
                ActionButton("Record an Event on the Second Instance") { second.events.recordEvent("event-on-second-instance") }
            } header: {
                Text("A second instance")
            } footer: {
                Text("Its own app key, server, device ID, request queue and storage namespace. It cannot see the default instance's data, so one application can report to two dashboards at once.")
            }

            Section("Registry") {
                ActionButton("List Instances") {
                    let names = Countly.listInstances()
                    AppLog.shared.log(names.isEmpty ? "no named instances" : names.joined(separator: ", "))
                }
                ActionButton("Look the Second Instance up") {
                    AppLog.shared.log("exists: \(Countly.getInstance(named: secondName) != nil)")
                }
            }

            Section {
                ActionButton("Halt the Second Instance") { second.halt() }
                ActionButton("Halt it and Clear its Storage") { second.halt(clearStorage: true) }
                ActionButton("Halt Every Instance") { Countly.haltAllInstances() }
                ActionButton("Halt the Default Instance") { Countly.shared.halt() }
                ActionButton("Halt the Default Instance and Clear Storage") { Countly.shared.halt(clearStorage: true) }
            } header: {
                Text("Shutting down")
            } footer: {
                Text("Halting stops an instance but leaves what it wrote on disk. Clearing storage erases every key it owns, which is what a data deletion request needs.")
            }
        }
    }
}
