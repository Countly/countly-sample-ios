// RequestsUtilitiesView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct RequestsUtilitiesView: View {
    private var cly: Countly { Countly.sharedInstance() }
    @ObservedObject private var session = SDKSession.shared
    @State private var showHostPrompt = false
    @State private var showAppKeyPrompt = false
    @State private var newHost = ""
    @State private var newAppKey = ""

    var body: some View {
        Form {
            Section("Override config") {
                Button("Set New Host…") {
                    newHost = session.activeHost ?? ""
                    showHostPrompt = true
                }
                Button("Set New App Key…") {
                    newAppKey = session.activeAppKey ?? ""
                    showAppKeyPrompt = true
                }
                ActionButton("Set New URLSessionConfiguration") { cly.setNewURLSessionConfiguration(.default) }
                ActionButton("Add Custom Network Request Headers") { cly.addCustomNetworkRequestHeaders(["X-Sample": "1"]) }
            }
            Section("Queue") {
                ActionButton("Print Queue Size") { AppLog.shared.log("\(queue.count) requests queued") }
                ActionButton("Attempt to Send Stored Requests") { queue.attemptToSendStoredRequests() }
                ActionButton("Flush Queues") { queue.flushQueues() }
            }

            Section {
                ActionButton("Replace All App Keys with the Current One") { queue.replaceAllAppKeysInQueueWithCurrentAppKey() }
                ActionButton("Remove Requests with a Different App Key") { queue.removeDifferentAppKeysFromQueue() }
            } header: {
                Text("App key maintenance")
            } footer: {
                Text("For an application whose app key changed, deciding whether the requests queued under the old one are re-attributed or dropped.")
            }
            Section {
                ActionButton("Re-initialize with Setup values") {
                    session.reset(clearStorage: false)
                    session.initialize(with: SetupStore().load())
                }
                ActionButton("Halt and return to Setup") { session.reset(clearStorage: false) }
                Button("Halt, clear SDK storage and return to Setup", role: .destructive) {
                    AppLog.shared.log("Halt (clear storage)")
                    session.reset(clearStorage: true)
                }
            } header: { Text("Lifecycle") }
              footer: { Text("Clearing storage drops the request queue and the stored device ID; the Setup values are kept.") }
        }
        .alert("Set New Host", isPresented: $showHostPrompt) {
            TextField("https://your.server.ly", text: $newHost)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            Button("Apply") { session.setNewHost(newHost) }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Requests already in the queue keep the host they were created for.")
        }
        .alert("Set New App Key", isPresented: $showAppKeyPrompt) {
            TextField("App key", text: $newAppKey)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            Button("Apply") { session.setNewAppKey(newAppKey) }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Requests already in the queue keep their app key.")
        }
    }
}
