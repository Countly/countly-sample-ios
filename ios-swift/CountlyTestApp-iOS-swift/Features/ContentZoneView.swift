// ContentZoneView.swift
import SwiftUI
import Countly

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
                ActionButton("Refresh Content Zone") { content.refreshContentZone() }
            } header: { Text("Content zone") }
              footer: { Text("Content is server-driven; configure a content zone targeted to this device. Results appear in the log.") }
        }
    }
}
