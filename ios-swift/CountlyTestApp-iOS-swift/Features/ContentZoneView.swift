// ContentZoneView.swift
import SwiftUI
import Countly

struct ContentZoneView: View {
    private var content: CountlyContentBuilder { Countly.sharedInstance().content() }
    var body: some View {
        Form {
            Section {
                ActionButton("Enter Content Zone") { content.enterContentZone() }
                ActionButton("Exit Content Zone") { content.exitContentZone() }
                ActionButton("Refresh Content Zone") { content.refreshContentZone() }
                ActionButton("Preview Content (by id)") { content.previewContent("CONTENT_ID") }
            } footer: { Text("Content is server-driven; configure a content zone targeted to this device.") }
        }
    }
}
