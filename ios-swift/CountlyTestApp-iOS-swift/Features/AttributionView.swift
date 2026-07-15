// AttributionView.swift
import SwiftUI
import Countly

struct AttributionView: View {
    private var cly: Countly { Countly.sharedInstance() }
    var body: some View {
        Form {
            Section("Current") {
                ActionButton("Record Direct Attribution") { cly.recordDirectAttribution(withCampaignType: "countly", andCampaignData: "{\"cid\":\"123\",\"cuid\":\"456\"}") }
                ActionButton("Record Indirect Attribution") { cly.recordIndirectAttribution(["idfa": "00000000-0000-0000-0000-000000000000"]) }
            }
            Section {
                ActionButton("Record Attribution ID (deprecated)") { cly.recordAttributionID("attribution-id") }
            } header: { Text("Legacy (deprecated)") }
              footer: { Text("Prefer recordDirectAttributionWithCampaignType:andCampaignData: / recordIndirectAttribution:.") }
        }
    }
}
