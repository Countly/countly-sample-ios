// ContentZoneView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct ContentZoneView: View {
    private var content: ContentAPI { Countly.shared.content }
    @AppStorage("content.lastPreviewID") private var contentID = ""
    @State private var newDeviceID = ""

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

            Section {
                ActionButton("Refresh Content Zone") { content.refreshContentZone() }
            } header: {
                Text("While inside the zone")
            } footer: {
                Text("Content is server-driven; configure a content zone targeted to this device. Results appear in the log.")
            }

            Section {
                LabeledField("Device ID", text: $newDeviceID, placeholder: "new_device_id")
                ActionButton("Change Device ID") {
                    let id = newDeviceID.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !id.isEmpty else {
                        AppLog.shared.log("Enter a device ID first")
                        return
                    }
                    Countly.shared.deviceID.setID(id)
                    Countly.shared.consent.giveAllConsents()
                    AppLog.shared.log("Device ID changed to \(id), all consents given")
                }
            } header: {
                Text("Device ID")
            } footer: {
                Text("Content is picked per user, so switching the device ID is how a different audience is checked. Consent is granted again afterwards because a change without merge starts a new user with no consent.")
            }
        }
    }
}
