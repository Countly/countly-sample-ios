// AttributionView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct AttributionView: View {
    private var attribution: AttributionAPI { Countly.shared.attribution }

    var body: some View {
        Form {
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
                Text("The campaign the user came from, as the JSON a deep link handed the application. Only the countly campaign type is supported.")
            }

            Section {
                ActionButton("Record Indirect Attribution") { attribution.recordIndirectAttribution(["idfa": "ADVERTISING_ID"]) }
                ActionButton("… with Several Identifiers") { attribution.recordIndirectAttribution(["idfa": "ADVERTISING_ID", "idfv": "VENDOR_ID"]) }
            } header: {
                Text("Indirect")
            } footer: {
                Text("Advertising identifiers the host application obtained itself. The SDK never collects them on its own.")
            }
        }
    }
}
