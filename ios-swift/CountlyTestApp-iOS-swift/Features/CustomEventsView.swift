// CustomEventsView.swift
import SwiftUI
import Countly

struct CustomEventsView: View {
    private var cly: Countly { Countly.sharedInstance() }
    var body: some View {
        Form {
            Section("Events") {
                ActionButton("Record Event") { cly.recordEvent("button-click") }
                ActionButton("Record Event with Count") { cly.recordEvent("button-click", count: 5) }
                ActionButton("Record Event with Sum") { cly.recordEvent("button-click", sum: 1.99) }
                ActionButton("Record Event with Duration") { cly.recordEvent("button-click", duration: 3.14) }
                ActionButton("Record Event with Count & Sum") { cly.recordEvent("button-click", count: 5, sum: 1.99) }
                ActionButton("Record Event with Segmentation") { cly.recordEvent("button-click", segmentation: ["k": "v"]) }
                ActionButton("… Segmentation & Count") { cly.recordEvent("button-click", segmentation: ["k": "v"], count: 5) }
                ActionButton("… Segmentation, Count & Sum") { cly.recordEvent("button-click", segmentation: ["k": "v"], count: 5, sum: 1.99) }
                ActionButton("… Segmentation, Count, Sum & Dur.") { cly.recordEvent("button-click", segmentation: ["k": "v"], count: 5, sum: 1.99, duration: 0.314) }
            }
            Section("Timed events") {
                ActionButton("Start Event") { cly.startEvent("timed-event") }
                ActionButton("End Event") { cly.endEvent("timed-event") }
                ActionButton("End Event with Segmentation, Count & Sum") { cly.endEvent("timed-event", segmentation: ["k": "v"], count: 1, sum: 0) }
                ActionButton("Cancel Event") { cly.cancelEvent("timed-event") }
            }
            Section("Reserved / internal events") {
                ActionButton("Basic Internal NPS Event") { cly.recordEvent(kCountlyReservedEventNPS) }
                ActionButton("Basic Internal Survey Event") { cly.recordEvent(kCountlyReservedEventSurvey) }
                ActionButton("Basic Internal Star-Rating Event") { cly.recordEvent("[CLY]_star_rating") }
                ActionButton("Basic Internal Orientation Event") { cly.recordEvent("[CLY]_orientation") }
            }
        }
    }
}
