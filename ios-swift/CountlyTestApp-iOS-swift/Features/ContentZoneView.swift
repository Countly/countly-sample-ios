// ContentZoneView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct ContentZoneView: View {
    @State private var newDeviceID = ""

    private var content: ContentAPI { Countly.shared.content }

    var body: some View {
        Form {
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
