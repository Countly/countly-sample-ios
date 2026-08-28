// RequestsUtilitiesView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct RequestsUtilitiesView: View {
    private var queue: RequestQueueAPI { Countly.shared.requestQueue }

    var body: some View {
        Form {
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

            Section("Flush runnables") {
                ActionButton("Add a Queue Flush Runnable") {
                    queue.addQueueFlushRunnable { AppLog.shared.log("the queue drained with nothing failing") }
                }
                ActionButton("Clear Queue Flush Runnables") { queue.clearQueueFlushRunnables() }
            }

            Section("Direct requests and metrics") {
                ActionButton("Add a Direct Request") { Countly.shared.addDirectRequest(["custom_key": "custom_value"]) }
                ActionButton("Record a Metrics Override") { Countly.shared.recordMetrics(["_custom_metric": "custom_value"]) }
            }

            Section {
                ActionButton("Set a New Host") { Countly.shared.setNewHost("https://your.other.server.ly") }
                ActionButton("Set a New App Key") { Countly.shared.setNewAppKey("YOUR_OTHER_APP_KEY") }
                ActionButton("Add Custom Network Request Headers") {
                    Countly.shared.addCustomNetworkRequestHeaders(["X-My-Custom-Field": "my_custom_value"])
                }
                ActionButton("Set a New URL Session Configuration") {
                    let configuration = URLSessionConfiguration.default
                    configuration.timeoutIntervalForRequest = 15
                    configuration.allowsCellularAccess = false
                    Countly.shared.setNewURLSessionConfiguration(configuration)
                }
            } header: {
                Text("Networking")
            } footer: {
                Text("Changing the app key or host mid-run leaves whatever is already queued alone; the maintenance calls above decide what happens to it.")
            }
        }
    }
}
