// PushNotificationsView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// Push, which macOS supports through APNs like iOS does.
///
/// `PushModule` and `PushRuntime` are guarded with
/// `canImport(UserNotifications) && (os(iOS) || os(visionOS) || os(macOS))`, and
/// macOS has its own launch notification replay for a notification that started
/// the application.
struct PushNotificationsView: View {
    private var push: PushAPI { AppContext.active.push }

    var body: some View {
        FeatureList {
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
                FootnoteText("Push has to be switched on in Setup before any of this does anything: the module is inert unless the feature was requested at init. The token is reported automatically once permission is granted.")
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
                FootnoteText("Index 0 is the notification body, 1 and up are its action buttons. The SDK does this by itself unless automatic push handling is disabled in the configuration.")
            }

            Section {
                FootnoteText("A macOS build needs the aps-environment entitlement and a provisioning profile before a token ever arrives, so an unsigned local build will report a registration failure rather than a token. The permission prompt and the action recording above work regardless.")
            } header: {
                Text("What a local build can and cannot do")
            }
        }
    }
}
