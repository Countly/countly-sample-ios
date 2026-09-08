// EventComposerView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// Composes a custom event by hand, rather than recording a canned one.
///
/// The hardcoded rows elsewhere show the shape of each call; this shows what a
/// real event looks like when the values come from somewhere other than the
/// sample's own source code.
struct EventComposerView: View {

    @State private var key = "purchase"
    @State private var count = "1"
    @State private var sum = ""
    @State private var duration = ""
    @State private var segmentation: [KeyValue] = [KeyValue(key: "item", value: "hat")]
    @State private var useTimedEvent = false

    var body: some View {
        Form {
            Section("Event") {
                LabeledField("Key", text: $key)
                LabeledField("Count", text: $count, keyboard: .numberPad)
                LabeledField("Sum", text: $sum, keyboard: .decimalPad, placeholder: "optional")
                LabeledField("Duration", text: $duration, keyboard: .decimalPad, placeholder: "optional")
            }

            KeyValueEditor(title: "Segmentation", pairs: $segmentation)

            Section {
                Toggle("Record as a timed event", isOn: $useTimedEvent)
            } footer: {
                Text(useTimedEvent
                     ? "Starts the event now. Record it again with this off, or use End, to close it and let the SDK measure the duration."
                     : "Recorded immediately with the values above.")
            }

            Section {
                Button("Record Event") { record() }
                if useTimedEvent {
                    Button("End Timed Event") { endTimed() }
                    Button("Cancel Timed Event") {
                        Countly.shared.events.cancelEvent(key)
                        AppLog.shared.log("cancelled timed event '\(key)'")
                    }
                }
            }
        }
    }

    private var parsedSegmentation: [String: Any]? {
        let pairs = segmentation.filter { !$0.key.isEmpty }
        guard !pairs.isEmpty else { return nil }
        return Dictionary(pairs.map { ($0.key, $0.typedValue) }, uniquingKeysWith: { _, last in last })
    }

    private func record() {
        guard !key.isEmpty else { return AppLog.shared.log("an event needs a key") }

        if useTimedEvent {
            Countly.shared.events.startEvent(key)
            AppLog.shared.log("started timed event '\(key)'")
            return
        }

        Countly.shared.events.recordEvent(key,
                                          segmentation: parsedSegmentation,
                                          count: Int(count) ?? 1,
                                          sum: Double(sum) ?? 0,
                                          duration: Double(duration) ?? 0)
        AppLog.shared.log("recorded '\(key)' with \(parsedSegmentation?.count ?? 0) segmentation key(s)")
    }

    private func endTimed() {
        Countly.shared.events.endEvent(key,
                                       segmentation: parsedSegmentation,
                                       count: Int(count) ?? 1,
                                       sum: Double(sum) ?? 0)
        AppLog.shared.log("ended timed event '\(key)'")
    }
}
