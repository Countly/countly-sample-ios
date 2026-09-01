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
                .frame(minWidth: 940, minHeight: 620)
        }
        .windowToolbarStyle(.unified)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {

        // The server and app key are edited from the Setup screen and stored in
        // UserDefaults, so the sample builds and runs with nothing configured.
        let config = SDKSetup.makeConfig()

        if SDKSetup.isPlaceholder {
            NSLog("Please do not use the default app key and server url")
            AppLog.shared.log("running against the placeholder server, open Setup to point it somewhere real")
        }

        // A notification that launched the application, which macOS delivers here
        // rather than through the notification centre delegate.
        config.launchNotification = notification.userInfo?[NSApplication.launchUserNotificationUserInfoKey] as? [AnyHashable: Any]

        // ---------------------------------------------------------------------
        // Optional configuration, left commented so the sample starts minimal.
        // Everything reachable from the Setup screen is applied in `SDKSetup`.
        // Anything guarded to iOS or tvOS in the SDK is deliberately absent.
        // ---------------------------------------------------------------------

//      config.consents = [.sessions, .events, .viewTracking]           // Consent granted at init
//      config.resetStoredDeviceID = true                               // Ignore the stored ID and start fresh

//      config.enableManualSessionControlHybridMode = true              // Manual begin, automatic updates
//      config.updateSessionPeriod = 30                                 // Session update interval, default 60 seconds

//      config.globalViewSegmentation = ["tier": "gold"]                // Segmentation added to every view
//      config.disableViewRestartForManualRecording = true              // Do not reopen manual views after a background

//      config.eventSendThreshold = 5                                   // Flush after this many events, default 100
//      config.storedRequestsLimit = 500                                // Request queue cap, default 1000
//      config.requestDropAgeHours = 24                                 // Drop requests older than this
//      config.alwaysUsePOST = true                                     // Force POST instead of GET
//      config.secretSalt = "secretsalt"                                // Parameter tampering protection
//      config.pinnedCertificates = ["count.ly.cer"]                    // Certificate pinning
//      config.customNetworkRequestHeaders = ["X-My-Field": "value"]    // Headers added to every request

//      config.location = CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917)
//      config.city = "Tokyo"
//      config.isoCountryCode = "JP"
//      config.ipAddress = "128.0.0.1"
//      config.disableLocation = true                                   // Send no location at all

//      config.crashSegmentation = ["SomeOtherSDK": "v3.4.5"]           // Segmentation added to every crash
//      config.crashes.crashFilterCallback = { crash in
//          crash.name.contains("Ignored")                              // Return true to drop the report
//      }
//      config.shouldSendCrashReportCallback = { report in
//          report["_name"] as? String != "Ignored"                     // Return false to drop the report
//      }

//      config.enableRemoteConfigValueCaching = true                    // Keep values a download did not return
//      config.enrollABOnRCDownload = true                              // Enroll into A/B tests on download
//      config.remoteConfigRegisterGlobalCallback { result, error, full, values in
//          print("remote config downloaded: \(values.count) values")   // Fires on every download
//      }

//      config.apm.appStartTimestampOverride = 1700000000000            // Override the process start timestamp

//      config.content.webViewDisplayOption = .immersive                // How the content web view is presented
//      config.content.disableZoom = true                               // Block pinch and double tap zoom
//      config.content.enableContentReloadOnStall = true                // Reload a page that never reports itself shown
//      config.content.contentReloadOnStallTimeout = 1000               // How long to wait first, in milliseconds

//      config.sdkInternalLimits.maxKeyLength = 128
//      config.sdkInternalLimits.maxValueSize = 256
//      config.sdkInternalLimits.maxValueSizePicture = 4096
//      config.sdkInternalLimits.maxSegmentationValues = 100
//      config.sdkInternalLimits.maxBreadcrumbCount = 100
//      config.sdkInternalLimits.maxStackTraceLinesPerThread = 30
//      config.sdkInternalLimits.maxStackTraceLineLength = 200

//      config.experimental.enableVisibilityTracking = true             // Stamp every event with cly_v
//      config.experimental.enablePreviousNameRecording = true          // Report the previous view and event name

//      config.sendPushTokenAlways = true                               // Report the token whatever the permission state
//      config.doNotShowAlertForNotifications = true                    // Suppress the foreground alert
//      config.disableAutomaticPushHandling = true                      // Wire the delegates up yourself

//      config.instanceName = "secondary"                               // Names this instance, giving it its own storage

//      config.customMetrics = ["_custom_metric": "custom_value"]       // Added to the metrics sent with every session
//      config.providedUserProperties = ["tier": "gold"]                // User properties applied at init

//      config.urlSessionConfiguration = .default                       // Supply your own URLSession configuration
//      config.requestTimeoutDuration = 30                              // Per request timeout, in seconds
//      config.shouldIgnoreTrustCheck = true                            // Skip server trust evaluation, debug only
//      config.disableBackoffMechanism = true                           // Ignore the server asking the SDK to slow down

//      config.indirectAttribution = ["idfa": "ADVERTISING_ID"]         // Advertising identifiers, reported at init

        Countly.shared.start(with: config)
    }

    // The SDK takes these over automatically. They are here only to show what
    // `disableAutomaticPushHandling` would make necessary.

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
