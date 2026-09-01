// InitModel.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import Foundation
import SwiftUI

/// Every `CountlyConfig` setting the Init screen edits, plus the code that turns
/// them into a configuration and starts the SDK.
///
/// Modelled on the JavaFX demo's `InitPane`: the SDK is not started at launch, so
/// every option here is actually testable rather than being a comment in an app
/// delegate that nobody can reach at runtime.
///
/// Text fields hold strings rather than numbers on purpose. An empty field means
/// "leave the SDK's default alone", and the field's prompt shows what that default
/// is. A number bound directly would have to hold something, which would make
/// every default look like a deliberate override.
@MainActor
final class InitModel: ObservableObject {

    static let shared = InitModel()

    // MARK: - Core and identity

    @Published var host = AppContext.defaultHost
    @Published var appKey = AppContext.defaultAppKey
    @Published var deviceID = AppContext.defaultDeviceID
    @Published var appVersion = AppContext.appVersion
    @Published var instanceName = AppContext.defaultInstanceName
    @Published var secretSalt = ""
    @Published var pinnedCertificates = ""
    @Published var logLevel = CountlyLogLevel.debug
    @Published var enableDebug = true

    // MARK: - Features

    /// One per `CountlyFeature`, all on, matching the JavaFX demo's "enable all"
    /// default. Both of these are opt in in the SDK itself.
    @Published var features: Set<CountlyFeature> = Set(CountlyFeature.allCases)

    // MARK: - Flags

    @Published var requiresConsent = false
    @Published var enableAllConsents = true
    @Published var manualSessionHandling = false
    @Published var enableManualSessionControlHybridMode = false
    @Published var alwaysUsePOST = false
    @Published var disableLocation = false
    @Published var temporaryDeviceIDMode = false
    @Published var resetStoredDeviceID = false
    @Published var enableRemoteConfigAutomaticTriggers = false
    @Published var enableRemoteConfigValueCaching = false
    @Published var enrollABOnRCDownload = false
    @Published var disableBackoffMechanism = false
    @Published var disableSDKBehaviorSettingsUpdates = false
    @Published var shouldIgnoreTrustCheck = false
    @Published var disableViewRestartForManualRecording = false
    @Published var sendPushTokenAlways = false
    @Published var disableAutomaticPushHandling = false
    @Published var doNotShowAlertForNotifications = false

    // Shown disabled: nothing behind them exists on macOS. See `InitView`.
    @Published var enableAutomaticViewTracking = false
    @Published var enableOrientationTracking = true

    // Experimental sub-config.
    @Published var enablePreviousNameRecording = false
    @Published var enableVisibilityTracking = false

    // MARK: - Tuning

    /// Pre-filled to 1, the one deliberate non-default on this screen: with the
    /// SDK's own threshold of 100 a tester would press a button ten times and see
    /// nothing leave the device. Flushing every event makes the request log
    /// readable.
    @Published var eventSendThreshold = "1"
    @Published var updateSessionPeriod = ""
    @Published var storedRequestsLimit = ""
    @Published var requestDropAgeHours = ""
    @Published var requestTimeoutDuration = ""

    @Published var maxKeyLength = ""
    @Published var maxValueSize = ""
    @Published var maxValueSizePicture = ""
    @Published var maxSegmentationValues = ""
    @Published var maxBreadcrumbCount = ""
    @Published var maxStackTraceLineLength = ""
    @Published var maxStackTraceLinesPerThread = ""

    // MARK: - Content sub-config

    @Published var contentZoneTimerInterval = ""
    @Published var contentDisplayOption = WebViewDisplayOption.immersive
    @Published var contentReloadOnStall = false
    @Published var contentReloadOnStallTimeout = ""
    @Published var contentDisableZoom = false
    @Published var contentDisableRotation = false

    // MARK: - APM sub-config

    @Published var apmAppStartTimeTracking = false
    @Published var apmForegroundBackgroundTracking = false
    @Published var apmManualAppLoadedTrigger = false
    @Published var apmAppStartTimestampOverride = ""

    // MARK: - Crashes sub-config

    @Published var crashFilterIgnored = false
    @Published var crashSegmentation = false

    // MARK: - Init-only callbacks and seeds

    /// These four have no runtime equivalent: a callback registered at init hears
    /// about the download the SDK does during init, and user properties applied at
    /// init are attached before anything else is recorded. Nothing on the feature
    /// screens can stand in for them, which is why they belong here.
    @Published var rcGlobalCallback = false
    @Published var shouldSendCrashReportCallback = false
    @Published var providedUserProperties = false

    // MARK: - Behaviour settings

    @Published var sdkBehaviorSettings = ""

    // MARK: - Status

    @Published private(set) var isStarted = false
    @Published private(set) var startedInstanceName = ""
    @Published private(set) var startedDeviceID = ""

    private init() {}

    // MARK: - Building the config

    /// Turns the form into a `CountlyConfig`.
    ///
    /// Only fields the tester filled in are applied. Everything left blank is not
    /// touched at all, so the object still carries whatever the SDK ships as the
    /// default rather than a value this screen invented.
    func makeConfig() -> CountlyConfig {
        let config = CountlyConfig()

        config.host = host.trimmingCharacters(in: .whitespaces)
        config.appKey = appKey.trimmingCharacters(in: .whitespaces)

        let name = instanceName.trimmingCharacters(in: .whitespaces)
        if !name.isEmpty { config.instanceName = name }

        let id = deviceID.trimmingCharacters(in: .whitespaces)
        if !id.isEmpty { config.deviceID = id }

        // The Swift SDK has no `applicationVersion` setter: the app version is a
        // device metric, and a custom metric of the same key overrides it.
        let version = appVersion.trimmingCharacters(in: .whitespaces)
        if !version.isEmpty { config.customMetrics[MetricKey.appVersion] = version }

        let salt = secretSalt.trimmingCharacters(in: .whitespaces)
        if !salt.isEmpty { config.secretSalt = salt }

        let certificates = pinnedCertificates
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        if !certificates.isEmpty { config.pinnedCertificates = certificates }

        config.enableDebug = enableDebug
        config.internalLogLevel = logLevel
        config.loggerDelegate = SDKLogRelay.shared

        config.features = CountlyFeature.allCases.filter { features.contains($0) }
        config.pushTestMode = .development
        config.launchNotification = AppContext.launchNotification

        config.requiresConsent = requiresConsent
        config.enableAllConsents = enableAllConsents
        config.manualSessionHandling = manualSessionHandling
        config.enableManualSessionControlHybridMode = enableManualSessionControlHybridMode
        config.alwaysUsePOST = alwaysUsePOST
        config.disableLocation = disableLocation
        config.temporaryDeviceIDMode = temporaryDeviceIDMode
        config.resetStoredDeviceID = resetStoredDeviceID
        config.enableRemoteConfigAutomaticTriggers = enableRemoteConfigAutomaticTriggers
        config.enableRemoteConfigValueCaching = enableRemoteConfigValueCaching
        config.enrollABOnRCDownload = enrollABOnRCDownload
        config.disableBackoffMechanism = disableBackoffMechanism
        config.disableSDKBehaviorSettingsUpdates = disableSDKBehaviorSettingsUpdates
        config.shouldIgnoreTrustCheck = shouldIgnoreTrustCheck
        config.disableViewRestartForManualRecording = disableViewRestartForManualRecording
        config.sendPushTokenAlways = sendPushTokenAlways
        config.disableAutomaticPushHandling = disableAutomaticPushHandling
        config.doNotShowAlertForNotifications = doNotShowAlertForNotifications

        config.experimental.enablePreviousNameRecording = enablePreviousNameRecording
        config.experimental.enableVisibilityTracking = enableVisibilityTracking

        apply(eventSendThreshold, "eventSendThreshold") { config.eventSendThreshold = $0 }
        apply(storedRequestsLimit, "storedRequestsLimit") { config.storedRequestsLimit = $0 }
        apply(requestDropAgeHours, "requestDropAgeHours") { config.requestDropAgeHours = $0 }
        apply(updateSessionPeriod, "updateSessionPeriod") { config.updateSessionPeriod = TimeInterval($0) }
        apply(requestTimeoutDuration, "requestTimeoutDuration") { config.requestTimeoutDuration = TimeInterval($0) }

        apply(maxKeyLength, "maxKeyLength") { config.sdkInternalLimits.maxKeyLength = $0 }
        apply(maxValueSize, "maxValueSize") { config.sdkInternalLimits.maxValueSize = $0 }
        apply(maxValueSizePicture, "maxValueSizePicture") { config.sdkInternalLimits.maxValueSizePicture = $0 }
        apply(maxSegmentationValues, "maxSegmentationValues") { config.sdkInternalLimits.maxSegmentationValues = $0 }
        apply(maxBreadcrumbCount, "maxBreadcrumbCount") { config.sdkInternalLimits.maxBreadcrumbCount = $0 }
        apply(maxStackTraceLineLength, "maxStackTraceLineLength") { config.sdkInternalLimits.maxStackTraceLineLength = $0 }
        apply(maxStackTraceLinesPerThread, "maxStackTraceLinesPerThread") { config.sdkInternalLimits.maxStackTraceLinesPerThread = $0 }

        config.content.webViewDisplayOption = contentDisplayOption
        config.content.enableContentReloadOnStall = contentReloadOnStall
        config.content.disableZoom = contentDisableZoom
        config.content.disableRotation = contentDisableRotation
        apply(contentZoneTimerInterval, "content.zoneTimerInterval") { config.content.zoneTimerInterval = $0 }
        apply(contentReloadOnStallTimeout, "content.contentReloadOnStallTimeout") { config.content.contentReloadOnStallTimeout = $0 }
        config.content.globalContentCallback = { status, data in
            AppLog.shared.log("content callback: \(status == .completed ? "completed" : "closed"), data: \(data)")
        }
        config.content.contentURLHandler = { url in
            AppLog.shared.log("content wants to open \(url), letting the SDK handle it")
            return false
        }

        config.apm.enableAppStartTimeTracking = apmAppStartTimeTracking
        config.apm.enableForegroundBackgroundTracking = apmForegroundBackgroundTracking
        config.apm.enableManualAppLoadedTrigger = apmManualAppLoadedTrigger
        apply(apmAppStartTimestampOverride, "apm.appStartTimestampOverride") { config.apm.appStartTimestampOverride = Int64($0) }

        if crashFilterIgnored {
            config.crashes.crashFilterCallback = { crash in
                let dropped = crash.name.contains("Ignored")
                AppLog.shared.log("crash filter saw '\(crash.name)', dropping: \(dropped)")
                return dropped
            }
        }
        if crashSegmentation {
            config.crashSegmentation = ["SomeOtherSDK": "v3.4.5"]
        }
        if shouldSendCrashReportCallback {
            config.shouldSendCrashReportCallback = { report in
                let keep = report["_name"] as? String != "Ignored"
                AppLog.shared.log("crash report callback saw '\(report["_name"] ?? "?")', keeping: \(keep)")
                return keep
            }
        }

        if rcGlobalCallback {
            config.remoteConfigRegisterGlobalCallback { result, error, fullUpdate, values in
                AppLog.shared.log("init remote config callback: \(result), full: \(fullUpdate), count: \(values.count)\(error.map { ", error: \($0.localizedDescription)" } ?? "")")
            }
        }

        if providedUserProperties {
            config.providedUserProperties = ["tier": "gold", "source": "macOS sample"]
        }

        let behaviour = sdkBehaviorSettings.trimmingCharacters(in: .whitespacesAndNewlines)
        if !behaviour.isEmpty { config.sdkBehaviorSettings = behaviour }

        return config
    }

    /// Applies an integer field, complaining rather than guessing when it does not
    /// parse. A blank field is not an error: it means "leave the default alone".
    private func apply(_ raw: String, _ label: String, _ setter: (Int) -> Void) {
        let text = raw.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        guard let value = Int(text) else {
            AppLog.shared.log("ignoring invalid \(label) value: '\(text)'")
            return
        }
        setter(value)
    }

    // MARK: - Lifecycle

    var instance: CountlyInstance {
        Countly.instance(named: instanceName.trimmingCharacters(in: .whitespaces))
    }

    func initialize() {
        guard !instance.isStarted else {
            AppLog.shared.log("this instance is already started, halt it before initializing again")
            return
        }

        let config = makeConfig()
        AppLog.shared.log("start(with:) host: \(config.host), appKey: \(config.appKey), features: \(config.features.map { String(describing: $0) })")

        // Pointed at the instance that is about to be started, so every feature
        // screen follows this initialization rather than the previous one.
        AppContext.activeInstanceName = instanceName.trimmingCharacters(in: .whitespaces)

        instance.start(with: config)
        refreshStatus()
    }

    func refreshStatus() {
        let current = instance
        isStarted = current.isStarted
        startedInstanceName = current.name
        startedDeviceID = current.deviceID.current ?? ""
    }
}
