// MultiThreadingView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct MultiThreadingView: View {

    var body: some View {
        FeatureList {
            Section {
                ForEach(1...8, id: \.self) { index in
                    ActionButton("Thread \(index)") { record(on: index) }
                }
            } header: {
                Text("Concurrent recording")
            } footer: {
                FootnoteText("Each button records ten events from its own queue. Every public call is safe from any thread; pressing several at once is the point.")
            }

            Section {
                ActionButton("All Eight at Once") { (1...8).forEach(record(on:)) }
            }
        }
    }

    private func record(on index: Int) {
        DispatchQueue(label: "sample.thread.\(index)").async {
            for step in 0..<10 {
                Countly.shared.events.recordEvent("multi-threading-event",
                                                  segmentation: ["thread": "\(index)", "index": "\(step)"])
            }
        }
    }
}
