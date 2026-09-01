// ContentZoneView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// The content zone, which is available on macOS.
///
/// `ContentModule` guards its fetch, placement and presentation with
/// `os(iOS) || os(visionOS) || os(macOS)`, and the web view is presented in an
/// `NSPanel` rather than an overlay window. Everything on this screen reaches the
/// server and puts something on screen.
struct ContentZoneView: View {
    @State private var newDeviceID = ""
    @State private var contentID = "CONTENT_ID"

    private var content: ContentAPI { AppContext.active.content }

    var body: some View {
        FeatureList {
            Section {
                ActionButton("Enter Content Zone") { content.enterContentZone() }
                ActionButton("Exit Content Zone") { content.exitContentZone() }
            } header: {
                Text("Zone")
            } footer: {
                FootnoteText("While the zone is entered the SDK asks the server for content to show, on the interval set in Setup.")
            }

            Section("While inside the zone") {
                ActionButton("Refresh Content Zone") { content.refreshContentZone() }
            }

            Section {
                LabeledField("Content ID", text: $contentID, placeholder: "CONTENT_ID")
                ActionButton("Preview this Content") { content.previewContent(contentID) }
            } header: {
                Text("Preview")
            } footer: {
                FootnoteText("Shows one content entry by ID, bypassing the zone and its triggers, which is how a piece of content is checked before it is released.")
            }

            Section {
                LabeledField("Device ID", text: $newDeviceID, placeholder: "new_device_id")
                Button("Change Device ID and Grant Consent") {
                    let id = newDeviceID.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !id.isEmpty else {
                        AppLog.shared.log("Enter a device ID first")
                        return
                    }
                    AppContext.active.deviceID.setID(id)
                    AppContext.active.consent.giveAllConsents()
                    AppLog.shared.log("Device ID changed to \(id), all consents given")
                }
            } header: {
                Text("Device ID")
            } footer: {
                FootnoteText("Content is picked per user, so switching the device ID is how a different audience is checked. Consent is granted again afterwards because a change without merge starts a new user with no consent.")
            }

            Section {
                FootnoteText("The global content callback and the URL handler are installed by the sample when the config is built, so an open, a close and any link the page tries to follow all land in the log below.")
            } header: {
                Text("Callbacks")
            }
        }
    }
}
