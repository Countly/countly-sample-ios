// SDKSetup.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import Foundation

/// Where the sample points, and what it switches on at init.
///
/// The values live in `UserDefaults` rather than in the source, so the sample
/// ships with a placeholder that reaches nothing and a tester can point it at a
/// real server from the Setup screen instead of editing and rebuilding. Init-time
/// options can only be applied at init, so the screen writes them here and the
/// next launch reads them.
enum SDKSetup {

    enum Key {
        static let host = "countlyHost"
        static let appKey = "countlyAppKey"
        static let requiresConsent = "countlyRequiresConsent"
        static let enableAllConsents = "countlyEnableAllConsents"
        static let manualSessions = "countlyManualSessionHandling"
        static let crashReporting = "countlyCrashReporting"
        static let pushNotifications = "countlyPushNotifications"
        static let logLevel = "countlyLogLevel"
        static let temporaryDeviceID = "countlyTemporaryDeviceIDMode"
        static let customDeviceID = "countlyCustomDeviceID"
        static let rcAutomaticTriggers = "countlyRCAutomaticTriggers"
        static let contentZoneInterval = "countlyContentZoneInterval"
        static let apmAppStart = "countlyAPMAppStartTracking"
        static let apmForegroundBackground = "countlyAPMForegroundBackgroundTracking"
        static let apmManualAppLoaded = "countlyAPMManualAppLoadedTrigger"
        static let behaviorSettings = "countlyBehaviorSettings"
        static let pinBehaviorSettings = "countlyPinBehaviorSettings"
    }

    /// What the sample starts with until someone points it somewhere real.
    ///
    /// These are the two values the SDK itself recognises as placeholders and
    /// refuses to initialize with, so an unconfigured sample says so loudly in the
    /// log instead of quietly sending nothing.
    static let placeholderHost = "https://YOUR_COUNTLY_SERVER"
    static let placeholderAppKey = "YOUR_APP_KEY"

    static var host: String {
        let stored = UserDefaults.standard.string(forKey: Key.host) ?? ""
        return stored.isEmpty ? placeholderHost : stored
    }

    static var appKey: String {
        let stored = UserDefaults.standard.string(forKey: Key.appKey) ?? ""
        return stored.isEmpty ? placeholderAppKey : stored
    }

    /// Whether the sample is still pointing at the placeholder.
    static var isPlaceholder: Bool {
        host == placeholderHost || appKey == placeholderAppKey
    }

    static func bool(_ key: String, default fallback: Bool = false) -> Bool {
        UserDefaults.standard.object(forKey: key) as? Bool ?? fallback
    }

    static func string(_ key: String) -> String {
        UserDefaults.standard.string(forKey: key) ?? ""
    }

    static func integer(_ key: String, default fallback: Int) -> Int {
        guard let stored = UserDefaults.standard.object(forKey: key) as? Int, stored > 0 else { return fallback }
        return stored
    }

    /// Builds the configuration the application starts with.
    ///
    /// Everything here is deliberately reachable from the Setup screen. What the
    /// SDK also offers but the sample does not surface is listed as comments in
    /// `AppDelegate`, so the full configuration surface stays visible in one place.
    static func makeConfig() -> CountlyConfig {
        let config = CountlyConfig()
        config.appKey = appKey
        config.host = host

        config.enableDebug = true
        config.internalLogLevel = CountlyLogLevel(rawValue: integer(Key.logLevel, default: CountlyLogLevel.debug.rawValue)) ?? .debug
        config.loggerDelegate = SDKLogRelay.shared

        // Push and crash reporting are opt in. Everything else is on by default.
        var features: [CountlyFeature] = []
        if bool(Key.crashReporting, default: true) { features.append(.crashReporting) }
        if bool(Key.pushNotifications) { features.append(.pushNotifications) }
        config.features = features
        config.pushTestMode = .development

        config.requiresConsent = bool(Key.requiresConsent)
        config.enableAllConsents = bool(Key.enableAllConsents, default: true)

        config.manualSessionHandling = bool(Key.manualSessions)

        config.temporaryDeviceIDMode = bool(Key.temporaryDeviceID)
        let customID = string(Key.customDeviceID)
        if !customID.isEmpty { config.deviceID = customID }

        config.enableRemoteConfigAutomaticTriggers = bool(Key.rcAutomaticTriggers)

        config.content.zoneTimerInterval = integer(Key.contentZoneInterval, default: 30)
        config.content.globalContentCallback = { status, data in
            AppLog.shared.log("content callback: \(status == .completed ? "completed" : "closed"), data: \(data)")
        }
        config.content.contentURLHandler = { url in
            AppLog.shared.log("content wants to open \(url), letting the SDK handle it")
            return false
        }

        config.apm.enableAppStartTimeTracking = bool(Key.apmAppStart)
        config.apm.enableForegroundBackgroundTracking = bool(Key.apmForegroundBackground)
        config.apm.enableManualAppLoadedTrigger = bool(Key.apmManualAppLoaded)

        let behavior = string(Key.behaviorSettings)
        if !behavior.isEmpty { config.sdkBehaviorSettings = behavior }
        config.disableSDKBehaviorSettingsUpdates = bool(Key.pinBehaviorSettings)

        return config
    }
}
