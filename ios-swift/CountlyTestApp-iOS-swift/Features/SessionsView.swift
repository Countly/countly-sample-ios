// SessionsView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct SessionsView: View {
    private var sessions: SessionsAPI { Countly.shared.sessions }

    var body: some View {
        Form {
            Section {
                ActionButton("Begin Session") { sessions.beginSession() }
                ActionButton("Update Session") { sessions.updateSession() }
                ActionButton("End Session") { sessions.endSession() }
            } header: {
                Text("Manual session control")
            } footer: {
                Text("These are ignored while automatic session tracking is on, and the SDK says so in the log. Set manualSessionHandling in the configuration to take control.")
            }

            Section {
                ActionButton("Suspend SDK") { Countly.shared.suspend() }
                ActionButton("Resume SDK") { Countly.shared.resume() }
            } header: {
                Text("Lifecycle")
            } footer: {
                Text("What the SDK does by itself on background and foreground: the event queue is flushed, the session is closed, and the request queue is written to disk.")
            }
        }
    }
}
