//
//  ContentView.swift
//  VisionOS Sample
//
//  Created by Deniz Erten on 7/15/26.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Countly

struct ContentView: View {

    @State private var status: String = "Countly started — tap to test"

    var body: some View {
        VStack(spacing: 16) {
            Text("Countly visionOS test")
                .font(.title)

            Text(status)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text("Feedback widgets")
                .font(.headline)
            HStack {
                Button("NPS")    { Countly.sharedInstance().feedback().presentNPS() }
                Button("Survey") { Countly.sharedInstance().feedback().presentSurvey() }
                Button("Rating") { Countly.sharedInstance().feedback().presentRating() }
                Button("List")   { listWidgets() }
            }

            Text("Content")
                .font(.headline)
            HStack {
                Button("Enter content zone") {
                    Countly.sharedInstance().beginSession()
                    Countly.sharedInstance().content().enterContentZone() }
                Button("Exit content zone")  { Countly.sharedInstance().content().exitContentZone() }
            }

            Divider().padding(.vertical, 8)

            ToggleImmersiveSpaceButton()
        }
        .padding(40)
    }

    private func listWidgets() {
        Countly.sharedInstance().feedback().getAvailableFeedbackWidgets { widgets, error in
            if let error {
                status = "getAvailableFeedbackWidgets error: \(error.localizedDescription)"
            } else {
                status = "Available widgets: \(widgets?.count ?? 0)"
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
