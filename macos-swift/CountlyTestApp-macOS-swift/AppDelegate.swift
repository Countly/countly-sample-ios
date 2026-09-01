// AppDelegate.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import AppKit
import SwiftUI

// The SDK sources are compiled into this target from the `countly-sdk-swift`
// checkout, so there is nothing to import.

@main
struct CountlyTestApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup("Countly") {
            RootView()
                .frame(minWidth: 980, minHeight: 640)
        }
        .windowToolbarStyle(.unified)
    }
}

/// The application delegate deliberately does not start the SDK.
///
/// Modelled on the JavaFX demo: the app opens on the Initialize screen and nothing
/// is initialized until someone presses the button there. A `start(with:)` here
/// would fix the whole configuration at launch, which would make every init-time
/// option on that screen untestable without editing this file and rebuilding.
final class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Captured now and handed to the config at initialization: macOS delivers a
        // notification that launched the application here, and by the time the
        // Initialize screen builds a config this notification is long gone.
        AppContext.launchNotification =
            notification.userInfo?[NSApplication.launchUserNotificationUserInfoKey] as? [AnyHashable: Any]

        AppLog.shared.log("application launched, the SDK is not started yet, open Initialize to start it")
    }

    // The SDK takes these over automatically once push is switched on at init.
    // They are here only to show what `disableAutomaticPushHandling` would make
    // necessary.

    func application(_ application: NSApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Countly.didRegisterForRemoteNotifications(deviceToken: deviceToken)
    }

    func application(_ application: NSApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Countly.didFailToRegisterForRemoteNotifications(error: error)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
