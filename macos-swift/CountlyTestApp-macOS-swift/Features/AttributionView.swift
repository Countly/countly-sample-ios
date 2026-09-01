// AttributionView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct AttributionView: View {
    private var attribution: AttributionAPI { Countly.shared.attribution }

    var body: some View {
        FeatureList {
            Section {
                ActionButton("Record Direct Attribution") {
                    attribution.recordDirectAttribution(campaignType: "countly",
                                                        campaignData: "{\"cid\":\"CAMPAIGN_ID\",\"cuid\":\"CAMPAIGN_USER_ID\"}")
                }
                ActionButton("… without a Campaign User ID") {
                    attribution.recordDirectAttribution(campaignType: "countly",
                                                        campaignData: "{\"cid\":\"CAMPAIGN_ID\"}")
                }
                ActionButton("… with an Unsupported Campaign Type") {
                    attribution.recordDirectAttribution(campaignType: "unsupported",
                                                        campaignData: "{\"cid\":\"CAMPAIGN_ID\"}")
                }
            } header: {
                Text("Direct")
            } footer: {
                FootnoteText("The campaign the user came from, as the JSON a deep link handed the application. Only the countly campaign type is supported.")
            }

            Section {
                ActionButton("Record Indirect Attribution") { attribution.recordIndirectAttribution([AttributionKey.idfa: "ADVERTISING_ID"]) }
                ActionButton("… with Several Identifiers") { attribution.recordIndirectAttribution([AttributionKey.idfa: "ADVERTISING_ID", AttributionKey.adid: "ADJUST_ID"]) }
            } header: {
                Text("Indirect")
            } footer: {
                FootnoteText("Advertising identifiers the host application obtained itself. The SDK never collects them on its own, and macOS has no IDFA of its own to collect.")
            }
        }
    }
}
