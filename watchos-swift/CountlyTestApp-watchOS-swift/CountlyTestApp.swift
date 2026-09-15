// CountlyTestApp.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI
import WatchKit
import Countly

@main
struct CountlyTestApp: App {

    @WKApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/// The SDK is started from the application delegate, the same place the other
/// samples start it, so the first session begins with the launch.
final class AppDelegate: NSObject, WKApplicationDelegate {

    func applicationDidFinishLaunching() {
        let config = CountlyConfig()
        config.appKey = "YOUR_APP_KEY"
        config.host = "https://your.server.ly"

        if config.appKey == "YOUR_APP_KEY" || config.host == "https://your.server.ly" {
            NSLog("Please do not use the default app key and server url")
        }

        config.enableDebug = true
        config.internalLogLevel = .verbose

        // Crash reporting is opt in. Push is not available to a watch application.
        config.features = [.crashReporting]

        // ---------------------------------------------------------------------
        // Optional configuration, left commented so the sample starts minimal.
        // ---------------------------------------------------------------------

//      config.requiresConsent = true                                   // Nothing is collected until consent is given
//      config.deviceID = "customDeviceID"                              // Custom device ID, otherwise the SDK generates one
//      config.updateSessionPeriod = 20                                 // Session update period, 20 seconds by default on watchOS
//      config.eventSendThreshold = 10                                  // Events buffered before a request is made
//      config.enableRemoteConfigAutomaticTriggers = true               // Remote config is downloaded at init and on device ID change
//      config.customMetrics = ["_custom_metric": "custom_value"]       // Added to the metrics sent with every session

        // Harness scenarios override the server and drive the SDK on launch, so a
        // watch run can be captured the way the phone and desktop runs are.
        Scenario.configure(config)

        Countly.shared.start(with: config)
        AppLog.shared.log("SDK started, host: \(config.host)")

        Scenario.runIfRequested()
    }

    /// Nothing to forward: the SDK observes the extension's own notifications and
    /// ends the session on resign active, begins the next on become active. These
    /// are here only to show where the transitions land in the log.
    func applicationDidBecomeActive() {
        AppLog.shared.log("application became active")
    }

    func applicationWillResignActive() {
        AppLog.shared.log("application will resign active")
    }
}
