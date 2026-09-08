// RequestsUtilitiesView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct RequestsUtilitiesView: View {
    private var queue: RequestQueueAPI { AppContext.active.requestQueue }

    @State private var newHost = ""
    @State private var newAppKey = ""

    var body: some View {
        FeatureList {
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
                FootnoteText("For an application whose app key changed, deciding whether the requests queued under the old one are re-attributed or dropped.")
            }

            Section("Flush runnables") {
                ActionButton("Add a Queue Flush Runnable") {
                    queue.addQueueFlushRunnable { AppLog.shared.log("the queue drained with nothing failing") }
                }
                ActionButton("Clear Queue Flush Runnables") { queue.clearQueueFlushRunnables() }
            }

            Section("Direct requests and metrics") {
                ActionButton("Add a Direct Request") { AppContext.active.addDirectRequest(["custom_key": "custom_value"]) }
                ActionButton("Record a Metrics Override") { AppContext.active.recordMetrics(["_custom_metric": "custom_value"]) }
            }

            Section {
                LabeledField("Server URL", text: $newHost, placeholder: AppContext.defaultHost)
                Button("Set a New Host") {
                    let host = newHost.trimmingCharacters(in: .whitespaces)
                    guard !host.isEmpty else { return AppLog.shared.log("enter a server URL first") }
                    AppContext.active.setNewHost(host)
                    AppLog.shared.log("host set to \(host) for this run only")
                }
                LabeledField("App key", text: $newAppKey, placeholder: AppContext.defaultAppKey)
                Button("Set a New App Key") {
                    let appKey = newAppKey.trimmingCharacters(in: .whitespaces)
                    guard !appKey.isEmpty else { return AppLog.shared.log("enter an app key first") }
                    AppContext.active.setNewAppKey(appKey)
                    AppLog.shared.log("app key set to \(appKey) for this run only")
                }
                ActionButton("Add Custom Network Request Headers") {
                    AppContext.active.addCustomNetworkRequestHeaders(["X-My-Custom-Field": "my_custom_value"])
                }
                ActionButton("Set a New URL Session Configuration") {
                    let configuration = URLSessionConfiguration.default
                    configuration.timeoutIntervalForRequest = 15
                    AppContext.active.setNewURLSessionConfiguration(configuration)
                }
            } header: {
                Text("Networking")
            } footer: {
                FootnoteText("These change the running instance and are forgotten on relaunch; Setup is what the next launch reads. Changing the app key or host mid-run leaves whatever is already queued alone, and the maintenance calls above decide what happens to it.")
            }
        }
    }
}
