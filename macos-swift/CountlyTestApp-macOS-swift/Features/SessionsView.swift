// SessionsView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct SessionsView: View {
    private var sessions: SessionsAPI { Countly.shared.sessions }

    var body: some View {
        FeatureList {
            Section {
                ActionButton("Begin Session") { sessions.beginSession() }
                ActionButton("Update Session") { sessions.updateSession() }
                ActionButton("End Session") { sessions.endSession() }
            } header: {
                Text("Manual session control")
            } footer: {
                FootnoteText("These are ignored while automatic session tracking is on, and the SDK says so in the log. Switch manual session handling on in Setup and relaunch to take control.")
            }

            Section {
                ActionButton("Suspend SDK") { Countly.shared.suspend() }
                ActionButton("Resume SDK") { Countly.shared.resume() }
            } header: {
                Text("Lifecycle")
            } footer: {
                FootnoteText("What the SDK does by itself when the application is hidden or terminates: the event queue is flushed, the session is closed, and the request queue is written to disk. On macOS the SDK deliberately ignores resigning active, so clicking away from the window does not end a session.")
            }
        }
    }
}
