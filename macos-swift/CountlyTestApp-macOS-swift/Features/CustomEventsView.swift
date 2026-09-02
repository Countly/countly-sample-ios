// CustomEventsView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct CustomEventsView: View {
    private var events: EventsAPI { AppContext.active.events }

    var body: some View {
        FeatureList {
            Section("Events") {
                ActionButton("Record Event") { events.recordEvent("button-click") }
                ActionButton("Record Event with Count") { events.recordEvent("button-click", count: 5) }
                ActionButton("Record Event with Sum") { events.recordEvent("button-click", sum: 1.99) }
                ActionButton("Record Event with Duration") { events.recordEvent("button-click", duration: 3.14) }
                ActionButton("Record Event with Count & Sum") { events.recordEvent("button-click", count: 5, sum: 1.99) }
                ActionButton("Record Event with Segmentation") { events.recordEvent("button-click", segmentation: ["k": "v"]) }
                ActionButton("… Segmentation & Count") { events.recordEvent("button-click", segmentation: ["k": "v"], count: 5) }
                ActionButton("… Segmentation, Count & Sum") { events.recordEvent("button-click", segmentation: ["k": "v"], count: 5, sum: 1.99) }
                ActionButton("… Segmentation, Count, Sum & Duration") { events.recordEvent("button-click", segmentation: ["k": "v"], count: 5, sum: 1.99, duration: 0.314) }
            }

            Section("Timed events") {
                ActionButton("Start Event") { events.startEvent("timed-event") }
                ActionButton("End Event") { events.endEvent("timed-event") }
                ActionButton("End Event with Segmentation, Count & Sum") { events.endEvent("timed-event", segmentation: ["k": "v"], count: 1, sum: 0) }
                ActionButton("Cancel Event") { events.cancelEvent("timed-event") }
                ActionButton("End an Event that was never started") { events.endEvent("never-started") }
            }

            Section {
                ActionButton("Record Event with Over-Long Key & Value") {
                    events.recordEvent(String(repeating: "k", count: 200),
                                       segmentation: [String(repeating: "s", count: 200): String(repeating: "v", count: 300)])
                }
                ActionButton("Record Event with Empty Key") { events.recordEvent("") }
                ActionButton("Record Event with Unsupported Value Type") {
                    events.recordEvent("unsupported", segmentation: ["date": Date()])
                }
            } header: {
                Text("Limits")
            } footer: {
                FootnoteText("Over-long keys and values are truncated to the configured limits. An empty key is dropped, and an unsupported value type is removed from the segmentation.")
            }
        }
    }
}
