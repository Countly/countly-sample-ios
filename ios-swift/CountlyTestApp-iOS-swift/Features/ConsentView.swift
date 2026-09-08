// ConsentView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct ConsentView: View {
    private var consent: ConsentAPI { Countly.shared.consent }

    var body: some View {
        Form {
            Section("Give") {
                ActionButton("Give Consent for Sessions") { consent.giveConsent(for: .sessions) }
                ActionButton("Give Consent for Events & Views") { consent.giveConsent(for: [.events, .viewTracking]) }
                ActionButton("Give All Consents") { consent.giveAllConsents() }
            }

            Section("Cancel") {
                ActionButton("Cancel Consent for Events") { consent.cancelConsent(for: .events) }
                ActionButton("Cancel Consent for Crashes & APM") { consent.cancelConsent(for: [.crashReporting, .performanceMonitoring]) }
                ActionButton("Cancel All Consents") { consent.cancelAllConsents() }
            }

            Section {
                ActionButton("Check Every Consent") {
                    let states = ConsentFeature.allCases
                        .map { "\($0.wireName): \(consent.hasConsent(for: $0) ? "yes" : "no")" }
                        .joined(separator: ", ")
                    AppLog.shared.log(states)
                }
            } header: {
                Text("Check")
            } footer: {
                Text("Without requiresConsent in the configuration every feature reports itself as consented and none of the calls above do anything.")
            }
        }
    }
}
