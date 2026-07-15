// MultiThreadingView.swift
import SwiftUI
import Countly

struct MultiThreadingView: View {
    @State private var queues: [Int: DispatchQueue] = [:]
    var body: some View {
        Form {
            Section {
                ForEach(1...8, id: \.self) { t in ActionButton("Thread \(t)") { fire(t) } }
            } footer: { Text("Each thread records 15 events on its own serial queue.") }
        }
    }
    private func fire(_ t: Int) {
        let q = queues[t] ?? DispatchQueue(label: "ly.count.multithreading\(t)")
        queues[t] = q
        let tag = String(t)
        for i in 0..<15 {
            q.async { Countly.sharedInstance().recordEvent("MultiThreadingEvent" + tag, segmentation: ["k": "v" + String(i)]) }
        }
    }
}
