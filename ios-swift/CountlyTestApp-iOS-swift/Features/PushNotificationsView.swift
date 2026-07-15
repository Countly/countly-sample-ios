// PushNotificationsView.swift
import SwiftUI
import Countly
import UserNotifications

struct PushNotificationsView: View {
    private var cly: Countly { Countly.sharedInstance() }
    var body: some View {
        Form {
            Section {
                ActionButton("Ask for Notification Permission") { cly.askForNotificationPermission() }
                ActionButton("Ask for Permission (with completion)") {
                    cly.askForNotificationPermission(options: [.badge, .alert, .sound]) { granted, error in
                        AppLog.shared.log("granted=\(granted) error=\(error?.localizedDescription ?? "nil")")
                    }
                }
                ActionButton("Record Push Notification Action") { cly.recordAction(forNotification: [:], clickedButtonIndex: 1) }
                ActionButton("Record Push Notification Token") { cly.recordPushNotificationToken() }
                ActionButton("Clear Push Notification Token") { cly.clearPushNotificationToken() }
            }
        }
    }
}
