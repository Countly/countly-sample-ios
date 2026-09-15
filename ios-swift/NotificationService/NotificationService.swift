// NotificationService.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import UserNotifications

/// Hands every notification to the SDK's service, which attaches the media and
/// action buttons carried in the Countly payload and delivers the content itself,
/// well inside the time the system allows.
///
/// The SDK's service source is compiled into this extension the same way the
/// application compiles the SDK, so nothing is imported. An SPM integration adds
/// the "CountlyNotificationService" product and imports it here instead.
final class NotificationService: UNNotificationServiceExtension {

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        CountlyNotificationService.didReceive(request, withContentHandler: contentHandler)
    }
}
