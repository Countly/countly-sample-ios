// ContentZoneView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct ContentZoneView: View {
    private var content: ContentAPI { Countly.shared.content }

    var body: some View {
        Form {
            Section {
                ActionButton("Enter Content Zone") { content.enterContentZone() }
                ActionButton("Enter Content Zone with Tags") { content.enterContentZone(tags: ["promo"]) }
                ActionButton("Exit Content Zone") { content.exitContentZone() }
            } header: {
                Text("Zone")
            } footer: {
                Text("While the zone is entered the SDK asks the server for content to show, on the interval set by zoneTimerInterval.")
            }

            Section("While inside the zone") {
                ActionButton("Refresh Content Zone") { content.refreshContentZone() }
                ActionButton("Change Content Tags") { content.changeContent(tags: ["seasonal"]) }
            }

            Section {
                ActionButton("Preview a Specific Content") { content.previewContent("CONTENT_ID") }
            } header: {
                Text("Preview")
            } footer: {
                Text("Shows one content entry by ID, bypassing the zone and its triggers, which is how a piece of content is checked before it is released.")
            }
        }
    }
}
