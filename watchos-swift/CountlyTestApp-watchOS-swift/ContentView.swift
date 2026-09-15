// ContentView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI
import Countly

/// One screen of actions, each exercising a feature the SDK offers on watchOS.
///
/// No feedback widgets or content: those are web views, and the watch has no
/// WebKit. Push notifications belong to the paired phone's application.
struct ContentView: View {

    @ObservedObject private var log = AppLog.shared
    @State private var viewID: String?
    @State private var eventCount = 0

    private var cly: CountlyInstance { Countly.shared }

    var body: some View {
        NavigationStack {
            List {
                Section("Events") {
                    Button("Record event") {
                        eventCount += 1
                        cly.events.recordEvent("watch_button", segmentation: ["count": eventCount, "source": "watch"])
                        log.log("event recorded, count: \(eventCount)")
                    }
                    Button("Timed event") {
                        cly.events.startEvent("watch_timed")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            cly.events.endEvent("watch_timed", segmentation: ["done": true], count: 1, sum: 0)
                            log.log("timed event ended")
                        }
                        log.log("timed event started")
                    }
                }

                Section("Views") {
                    Button(viewID == nil ? "Start view" : "Stop view") {
                        if let viewID {
                            cly.views.stopView(id: viewID)
                            self.viewID = nil
                            log.log("view stopped")
                        } else {
                            viewID = cly.views.startView("WatchView", segmentation: ["screen": "main"])
                            log.log("view started, id: \(viewID ?? "nil")")
                        }
                    }
                }

                Section("User profile") {
                    Button("Set properties") {
                        cly.userProfile.setProperties([
                            "name": "Watch Tester",
                            "username": "watch",
                            "email": "watch@example.com",
                            "byear": 1990,
                            "tier": "wearable",
                        ])
                        cly.userProfile.save()
                        log.log("user properties saved")
                    }
                }

                Section("Crashes") {
                    Button("Breadcrumb") {
                        cly.crashes.addCrashBreadcrumb("watch breadcrumb \(Date().timeIntervalSince1970)")
                        log.log("breadcrumb added")
                    }
                    Button("Handled error") {
                        cly.crashes.recordError("WatchHandledError", isFatal: false,
                                                stackTrace: ["ContentView.body", "Button.action"],
                                                segmentation: ["source": "watch"])
                        log.log("handled error recorded")
                    }
                    Button("Crash", role: .destructive) {
                        log.log("crashing on purpose")
                        let empty: [Int] = []
                        _ = empty[1]
                    }
                }

                Section("Remote config") {
                    Button("Download keys") {
                        cly.remoteConfig.downloadKeys { response, error, fullUpdate, values in
                            let keys = values.keys.sorted().joined(separator: ", ")
                            log.log("remote config: \(response), error: \(error?.localizedDescription ?? "none"), full: \(fullUpdate), keys: [\(keys)]")
                        }
                        log.log("remote config download requested")
                    }
                }

                Section("Sessions") {
                    Button("Begin session") { cly.sessions.beginSession(); log.log("begin session requested") }
                    Button("Update session") { cly.sessions.updateSession(); log.log("update session requested") }
                    Button("End session") { cly.sessions.endSession(); log.log("end session requested") }
                }

                Section("Device ID") {
                    Button("Change without merge") {
                        cly.deviceID.changeWithoutMerge("watch-\(Int(Date().timeIntervalSince1970))")
                        log.log("device ID changed without merge")
                    }
                    Button("Change with merge") {
                        cly.deviceID.changeWithMerge("watch-merged-\(Int(Date().timeIntervalSince1970))")
                        log.log("device ID changed with merge")
                    }
                }

                Section("Requests") {
                    Button("Send stored requests") {
                        cly.requestQueue.attemptToSendStoredRequests()
                        log.log("send requested")
                    }
                }

                Section("Log") {
                    ForEach(Array(log.lines.suffix(6).enumerated()), id: \.offset) { _, line in
                        Text(line).font(.footnote).foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Countly")
        }
    }
}
