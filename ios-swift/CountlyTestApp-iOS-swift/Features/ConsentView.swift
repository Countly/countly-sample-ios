// ConsentView.swift
import SwiftUI
import Countly

struct ConsentView: View {
    private var cly: Countly { Countly.sharedInstance() }
    var body: some View {
        Form {
            Section("Give") {
                ActionButton("Give All Consents") { cly.giveAllConsents() }
                ActionButton("Give Consent for Events") { cly.giveConsent(forFeature: .events) }
                ActionButton("Give Consent for [Events, Crashes]") { cly.giveConsent(forFeatures: [.events, .crashReporting]) }
            }
            Section("Cancel") {
                ActionButton("Cancel Consent for Events") { cly.cancelConsent(forFeature: .events) }
                ActionButton("Cancel Consent for [Events, Crashes]") { cly.cancelConsent(forFeatures: [.events, .crashReporting]) }
                ActionButton("Cancel Consent for All Features") { cly.cancelConsentForAllFeatures() }
            }
            Section {
                ActionButton("Give Consent for All Features (deprecated)") { cly.giveConsentForAllFeatures() }
            } header: { Text("Legacy (deprecated)") }
              footer: { Text("Prefer giveAllConsents().") }
        }
    }
}
