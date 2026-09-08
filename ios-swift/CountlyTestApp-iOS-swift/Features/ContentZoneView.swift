// ContentZoneView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct ContentZoneView: View {
    private var content: CountlyContentBuilder { Countly.sharedInstance().content() }
    @AppStorage("content.lastPreviewID") private var contentID = ""

    private var trimmedContentID: String { contentID.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        Form {
            Section {
                TextField("Content ID", text: $contentID)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                Button("Preview Content") {
                    AppLog.shared.log("Preview content \(trimmedContentID)")
                    content.previewContent(trimmedContentID)
                }
                .disabled(trimmedContentID.isEmpty)
            } header: { Text("Preview by ID") }
              footer: { Text("Fetches and shows one specific content by its ID, without starting periodic content updates. Experimental SDK API.") }

            Section {
                ActionButton("Enter Content Zone") { content.enterContentZone() }
                ActionButton("Exit Content Zone") { content.exitContentZone() }
            } header: {
                Text("Zone")
            } footer: {
                Text("While the zone is entered the SDK asks the server for content to show, on the interval set by zoneTimerInterval.")
            }

            Section("While inside the zone") {
                ActionButton("Refresh Content Zone") { content.refreshContentZone() }
            } header: { Text("Content zone") }
              footer: { Text("Content is server-driven; configure a content zone targeted to this device. Results appear in the log.") }
        }
    }
}
