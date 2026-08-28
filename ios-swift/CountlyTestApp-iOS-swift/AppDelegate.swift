//  AppDelegate.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import UIKit
import SwiftUI
import CoreLocation

// The SDK sources are compiled into this target from the `countly-sdk-swift`
// submodule, so there is nothing to import.

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let config = CountlyConfig()
        config.appKey = "parity_app_key"
        config.host = "http://localhost:8080"

        if config.appKey == "YOUR_APP_KEY" || config.host == "https://your.server.ly" {
            NSLog("Please do not use the default app key and server url")
        }

        config.enableDebug = true
        config.internalLogLevel = .debug

        // Push and crash reporting are opt in. Everything else is on by default.
        config.features = [.pushNotifications, .crashReporting]
        config.pushTestMode = .development

        // ---------------------------------------------------------------------
        // Optional configuration, left commented so the sample starts minimal.
        // ---------------------------------------------------------------------

//      config.requiresConsent = true                                   // Nothing is collected until consent is given
//      config.consents = [.sessions, .events, .viewTracking]           // Consent granted at init
//      config.enableAllConsents = true                                 // Grant everything at init

//      config.deviceID = "customDeviceID"                              // Custom device ID, otherwise the SDK generates one
//      config.temporaryDeviceIDMode = true                             // Hold everything back until a real ID is set
//      config.resetStoredDeviceID = true                               // Ignore the stored ID and start fresh

//      config.manualSessionHandling = true                             // The host application controls sessions
//      config.enableManualSessionControlHybridMode = true              // Manual begin, automatic updates
//      config.updateSessionPeriod = 30                                 // Session update interval, default 60 seconds

//      config.enableAutomaticViewTracking = true                       // Report a view for every view controller
//      config.automaticViewTrackingExclusionList = ["ViewController"]  // Screens automatic tracking should skip
//      config.globalViewSegmentation = ["tier": "gold"]                // Segmentation added to every view
//      config.enableOrientationTracking = false                        // Orientation events, on by default

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

//      config.enableRemoteConfigAutomaticTriggers = true               // Download at init and after a device ID change
//      config.enableRemoteConfigValueCaching = true                    // Keep values a download did not return
//      config.enrollABOnRCDownload = true                              // Enroll into A/B tests on download
//      config.remoteConfigRegisterGlobalCallback { result, error, full, values in
//          print("remote config downloaded: \(values.count) values")   // Fires on every download
//      }

//      config.apm.enableAppStartTimeTracking()                         // Report how long the app took to start
//      config.apm.enableForegroundBackgroundTracking()                 // Report foreground and background durations
//      config.apm.enableManualAppLoadedTrigger()                       // You call appLoadingFinished() yourself
//      config.apm.appStartTimestampOverride = 1700000000000            // Override the process start timestamp

//      config.content.enableContentZone()                              // Poll for content while the zone is entered
//      config.content.zoneTimerInterval = 30                           // Seconds between content checks
//      config.content.webViewDisplayOption = .immersive                // How the content web view is presented
//      config.content.disableZoom = true                               // Block pinch and double tap zoom
//      config.content.disableRotation = true                           // Pin the content to portrait
//      config.content.enableContentReloadOnStall = true                // Reload a page that never reports itself shown
//      config.content.contentReloadOnStallTimeout = 1000               // How long to wait first, in milliseconds
//      config.content.globalContentCallback = { status, data in
//          print("content \(status): \(data)")                         // Every content open and close
//      }
//      config.content.contentURLHandler = { url in
//          print("content wants to open \(url)"); return true          // Return true to handle it yourself
//      }

//      config.sdkInternalLimits.maxKeyLength = 128
//      config.sdkInternalLimits.maxValueSize = 256
//      config.sdkInternalLimits.maxValueSizePicture = 4096
//      config.sdkInternalLimits.maxSegmentationValues = 100
//      config.sdkInternalLimits.maxBreadcrumbCount = 100
//      config.sdkInternalLimits.maxStackTraceLinesPerThread = 30
//      config.sdkInternalLimits.maxStackTraceLineLength = 200

//      config.experimental.enableVisibilityTracking()                  // Stamp every event with cly_v
//      config.experimental.enablePreviousNameRecording()               // Report the previous view and event name

//      config.sendPushTokenAlways = true                               // Report the token whatever the permission state
//      config.doNotShowAlertForNotifications = true                    // Suppress the foreground alert
//      config.disableAutomaticPushHandling = true                      // Wire the delegates up yourself
//      config.launchNotification = launchOptions                       // macOS only: a notification that started the app

//      config.instanceName = "secondary"                               // Names this instance, giving it its own storage

//      config.customMetrics = ["_custom_metric": "custom_value"]       // Added to the metrics sent with every session
//      config.providedUserProperties = ["tier": "gold"]                // User properties applied at init

//      config.urlSessionConfiguration = .default                       // Supply your own URLSession configuration
//      config.requestTimeoutDuration = 30                              // Per request timeout, in seconds
//      config.shouldIgnoreTrustCheck = true                            // Skip server trust evaluation, debug only
//      config.disableBackoffMechanism = true                           // Ignore the server asking the SDK to slow down

//      config.sdkBehaviorSettings = "{}"                               // Behavior settings supplied by the developer
//      config.disableSDKBehaviorSettingsUpdates = true                 // Pin them, ignoring what the server sends

//      config.disableViewRestartForManualRecording = true              // Do not reopen manual views after a background

//      config.indirectAttribution = ["idfa": "ADVERTISING_ID"]         // Advertising identifiers, reported at init

//      config.shouldSendCrashReportCallback = { report in
//          report["_name"] as? String != "Ignored"                     // Return false to drop the report
//      }

        // Parity scenarios drive the SDK directly, so the same run can be captured
        // from both sample applications and the two captures diffed. See
        // Tools/parity/SCENARIOS.md.
        if UserDefaults.standard.string(forKey: "CountlyScenario") != nil {
            Scenario.configure(config, Scenario.name)
        }

        Countly.shared.start(with: config)

        if UserDefaults.standard.string(forKey: "CountlyScenario") != nil {
            // Delayed so init has finished and its own requests have left, which is
            // where each scenario's own traffic starts.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { Scenario.run() }
        }

        return true
    }

    // The SDK takes these over automatically. They are here only to show what
    // `disableAutomaticPushHandling` would make necessary.

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Countly.didRegisterForRemoteNotifications(deviceToken: deviceToken)
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Countly.didFailToRegisterForRemoteNotifications(error: error)
    }
}
