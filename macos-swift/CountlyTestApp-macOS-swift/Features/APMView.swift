// APMView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct APMView: View {
    private var performance: APMAPI { Countly.shared.performance }

    var body: some View {
        FeatureList {
            Section {
                ActionButton("Record a Network Trace") {
                    let now = Int64(Date().timeIntervalSince1970 * 1000)
                    performance.recordNetworkTrace("/api/items",
                                                   requestPayloadSize: 128,
                                                   responsePayloadSize: 1024,
                                                   responseStatusCode: 200,
                                                   startTime: now - 500,
                                                   endTime: now)
                }
                ActionButton("Record a Failed Network Trace") {
                    let now = Int64(Date().timeIntervalSince1970 * 1000)
                    performance.recordNetworkTrace("/api/items",
                                                   requestPayloadSize: 128,
                                                   responsePayloadSize: 0,
                                                   responseStatusCode: 500,
                                                   startTime: now - 2000,
                                                   endTime: now)
                }
            } header: {
                Text("Network")
            } footer: {
                FootnoteText("The SDK does not intercept the host application's traffic. Traces are reported by the application itself.")
            }

            Section("Custom traces") {
                ActionButton("Start Custom Trace") { performance.startCustomTrace("custom-trace") }
                ActionButton("End Custom Trace") { performance.endCustomTrace("custom-trace") }
                ActionButton("End Custom Trace with Metrics") { performance.endCustomTrace("custom-trace", metrics: ["steps": 3]) }
                ActionButton("Cancel Custom Trace") { performance.cancelCustomTrace("custom-trace") }
                ActionButton("Clear All Custom Traces") { performance.clearAllCustomTraces() }
            }

            Section {
                ActionButton("App Loading Finished") { performance.appLoadingFinished() }
            } header: {
                Text("App start")
            } footer: {
                FootnoteText("Closes the app start trace. Needs the manual app loaded trigger switched on in Setup, otherwise the SDK closes it itself.")
            }

            Section {
                FootnoteText("Foreground and background traces are driven by NSApplication activation on macOS, so switch that on in Setup and then click away from this window and back to see a pair of traces recorded.")
            } header: {
                Text("Foreground & background")
            }
        }
    }
}
