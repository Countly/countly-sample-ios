// PushNotificationsView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct PushNotificationsView: View {
    private var push: PushAPI { Countly.shared.push }

    var body: some View {
        Form {
            Section {
                ActionButton("Ask for Notification Permission") { push.askForNotificationPermission() }
                ActionButton("Ask with Options and a Completion Handler") {
                    // Badge, sound and alert.
                    push.askForNotificationPermission(options: 1 | 2 | 4) { granted, error in
                        AppLog.shared.log("permission granted: \(granted)\(error.map { ", error: \($0.localizedDescription)" } ?? "")")
                    }
                }
            } header: {
                Text("Permission")
            } footer: {
                Text("The token is reported automatically once permission is granted.")
            }

            Section("Token") {
                ActionButton("Record Push Token") { push.recordPushNotificationToken() }
                ActionButton("Clear Push Token") { push.clearPushNotificationToken() }
            }

            Section {
                ActionButton("Record a Notification Action") {
                    let userInfo: [AnyHashable: Any] = ["c": ["i": "NOTIFICATION_ID"]]
                    push.recordAction(for: userInfo, clickedButtonIndex: 0)
                }
                ActionButton("Record an Action Button Tap") {
                    let userInfo: [AnyHashable: Any] = ["c": ["i": "NOTIFICATION_ID"]]
                    push.recordAction(for: userInfo, clickedButtonIndex: 1)
                }
            } header: {
                Text("Actions")
            } footer: {
                Text("Index 0 is the notification body, 1 and up are its action buttons. The SDK does this by itself unless disableAutomaticPushHandling is set.")
            }

            Section {
                Text("A simulator has no APNs connection, so no token ever arrives and no notification can be delivered. Push needs a real device with a provisioning profile and a dashboard credential.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
