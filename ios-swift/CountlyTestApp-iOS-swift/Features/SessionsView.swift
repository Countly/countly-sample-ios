// SessionsView.swift
import SwiftUI
import Countly

struct SessionsView: View {
    private var cly: Countly { Countly.sharedInstance() }
    var body: some View {
        Form {
            Section {
                ActionButton("Begin Session") { cly.beginSession() }
                ActionButton("Update Session") { cly.updateSession() }
                ActionButton("End Session") { cly.endSession() }
            } footer: { Text("Meaningful only when 'manualSessionHandling' is enabled in the start config.") }
        }
    }
}
