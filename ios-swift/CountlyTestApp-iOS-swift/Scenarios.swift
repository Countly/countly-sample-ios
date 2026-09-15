//
//  Scenarios.swift
//
//  Manual test driver for the Swift SDK, the twin of CountlyScenarios.m in the
//  Objective-C sample application. One scenario per launch, selected with
//  -CountlyScenario <name>. The two files must stay in step or the comparison
//  means nothing. See Tools/parity/SCENARIOS.md.
//
//  This drives the SDK directly rather than through the interface, so a scenario
//  runs identically in both sample applications and the captures can be diffed.
//

import UIKit
import CoreLocation

enum Scenario {

    static var name: String {
        let value = UserDefaults.standard.string(forKey: "CountlyScenario") ?? ""
        return value.isEmpty ? "init-basic" : value
    }

    /// Applies the init-time configuration a scenario needs. Several scenarios are
    /// about a config flag rather than a call, so the setup is part of the scenario.
    static func configure(_ config: CountlyConfig, _ scenario: String) {
        applyParityBaseline(config)

        if scenario == "init-no-consent" || scenario.hasPrefix("consent-") {
            config.requiresConsent = true
        }

        if scenario == "session-manual" {
            config.manualSessionHandling = true
        }

        if scenario == "session-manual-hybrid" {
            config.manualSessionHandling = true
            config.enableManualSessionControlHybridMode = true
        }

        if scenario == "event-threshold" {
            config.eventSendThreshold = 3
        }

        if scenario == "event-limits" {
            config.sdkInternalLimits.maxKeyLength = 8
            config.sdkInternalLimits.maxValueSize = 10
            config.sdkInternalLimits.maxSegmentationValues = 3
        }

        if scenario == "view-segmentation" {
            config.globalViewSegmentation = ["from_config": "yes"]
        }

        if scenario == "deviceid-temporary" {
            config.temporaryDeviceIDMode = true
        }

        if scenario == "crash-segmentation" {
            config.crashSegmentation = ["global_crash": "from_config"]
        }

        if scenario.hasPrefix("rc-") {
            config.enableRemoteConfigAutomaticTriggers = true
            config.enableRemoteConfigValueCaching = true
        }

        if scenario == "rc-ab" {
            config.enrollABOnRCDownload = true
        }

        if scenario == "location" {
            config.location = CLLocationCoordinate2D(latitude: 38.4237, longitude: 27.1428)
            config.city = "Izmir"
            config.isoCountryCode = "TR"
            config.ipAddress = "10.0.0.1"
        }

        if scenario == "attribution" {
            config.campaignType = "countly"
            config.campaignData = "{\"cid\":\"config_campaign\",\"cuid\":\"config_user\"}"
        }

        if scenario == "salt" {
            config.secretSalt = "parity_salt"
        }

        if scenario == "migration-resume-cache" {
            config.deviceID = nil
            // Automatic triggers deliberately OFF, so anything read back came from
            // the cache the previous SDK wrote and not from a fresh download.
            config.enableRemoteConfigAutomaticTriggers = false
            config.enableRemoteConfigValueCaching = true
        }

        if scenario == "migration-resume" {
            // The device ID is left unset on purpose: whatever the previous SDK
            // stored has to win, and setting one here would mask a failure to read
            // it.
            config.deviceID = nil
        }

        if scenario.hasPrefix("view-auto") || scenario == "lifecycle-views-background" {
            config.enableAutomaticViewTracking = true

            // The host's own root screen is excluded so the capture contains only
            // the controllers the scenario presents. The two host applications have
            // different root screens, and that is a property of the hosts, not of
            // the SDKs. `view-auto-exclusion` is what actually tests the mechanism.
            var exclusions = ["CountlySampleRoot", "Countly"]
            if scenario == "view-auto-exclusion" {
                exclusions.append("AutoViewExcluded")
            }
            config.automaticViewTrackingExclusionList = exclusions
        }

        if scenario.hasPrefix("session-auto") || scenario.hasPrefix("lifecycle-") {
            // Short enough that the update timer fires inside the capture window.
            config.updateSessionPeriod = 5
        }

        // --- scenarios added for the Android comparison ----------------------

        if scenario == "consent-feature-group" {
            config.requiresConsent = true
        }
        if scenario == "apm-fg-bg-manual" || scenario == "apm-auto" {
            config.apm.enableForegroundBackgroundTracking = true
        }
        if scenario == "apm-auto" {
            config.apm.enableAppStartTimeTracking = true
        }
        if scenario == "queue-post-forced" {
            config.alwaysUsePOST = true
        }
        if scenario == "queue-headers" {
            config.customNetworkRequestHeaders = ["X-Parity-Init": "one"]
        }
        if scenario == "content-zone" || scenario == "sbs-listing-filters" {
            config.content.zoneTimerInterval = 16
        }
        if scenario == "deviceid-clear-stored" {
            config.deviceID = nil
            config.resetStoredDeviceID = true
        }
        if scenario == "init-user-properties" {
            config.providedUserProperties = ["name": "Init Name", "custom_init": 1]
        }
        if scenario == "init-metric-override" {
            config.customMetrics = ["_carrier": "ParityCarrier", "custom_metric": "123"]
        }
        if scenario == "init-all-consents" {
            config.requiresConsent = true
            config.enableAllConsents = true
        }
        if scenario == "init-consent-enabled" {
            config.requiresConsent = true
            config.consents = [.sessions, .events]
        }
        if scenario == "sbs-auto-off" {
            config.enableAutomaticViewTracking = true
            config.automaticViewTrackingExclusionList = ["CountlySampleRoot", "Countly"]
        }
        if scenario == "crash-filter" {
            config.crashes.crashFilterCallback = { crash in
                if crash.stackTrace.contains("DroppedByFilter") || crash.name.contains("DroppedByFilter") || crash.crashDescription.contains("DroppedByFilter") {
                    return true
                }
                crash.crashSegmentation["filtered"] = "yes"
                return false
            }
        }
        if scenario == "views-previous-name" {
            config.experimental.enablePreviousNameRecording = true
        }
        if scenario == "views-visibility" {
            config.experimental.enableVisibilityTracking = true
        }
        if scenario == "location-init-disabled" {
            config.disableLocation = true
        }
    }

    /// Resets the configuration to what both sample applications agree on.
    ///
    /// The two applications are demos first and are configured differently on
    /// purpose: one enables push and automatic remote config triggers, the other
    /// does not. Those differences reach the wire and would be read as SDK
    /// divergences. A scenario run therefore starts from a fixed baseline and the
    /// scenario's own overrides go on top of it.
    private static func applyParityBaseline(_ config: CountlyConfig) {
        config.appKey = "parity_app_key"
        config.host = "http://localhost:8080"
        config.deviceID = "parity-device"
        config.enableDebug = true
        config.internalLogLevel = .debug
        config.features = [.crashReporting]
        config.updateSessionPeriod = 60
        config.requiresConsent = false
        config.enableRemoteConfigAutomaticTriggers = false
        config.enableRemoteConfigValueCaching = false
        config.enableAutomaticViewTracking = false
    }

    // MARK: - View controller helpers

    /// Presents a plain view controller with a known title.
    ///
    /// Automatic view tracking names a view after its title before falling back to
    /// the class name, and a title is what makes the two host applications
    /// comparable: `NSStringFromClass` gives a bare name in Objective-C and a
    /// module qualified one in Swift.
    private static func presentTitled(_ title: String) {
        let controller = UIViewController()
        controller.title = title
        controller.view.backgroundColor = .systemBackground
        controller.modalPresentationStyle = .fullScreen

        topViewController()?.present(controller, animated: false)
    }

    private static func dismissTop() {
        topViewController()?.dismiss(animated: false)
    }

    private static func topViewController() -> UIViewController? {
        UIKitSupport.topViewController()
    }

    // MARK: - Steps

    static func steps(for scenario: String) -> [() -> Void] {
        let cly = Countly.shared
        var viewID: String?

        switch scenario {

        // --- lifecycle ----------------------------------------------------

        case "init-basic":
            return [
                { NSLog("[SCENARIO] nothing beyond init") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "init-no-consent":
            return [
                { cly.events.recordEvent("should_not_be_recorded") },
                { _ = cly.views.startView("ShouldNotBeRecorded") },
                { cly.userProfile.setProperty("name", value: "nobody"); cly.userProfile.save() },
                { cly.crashes.recordError("ShouldNotBeRecorded", isFatal: false, stackTrace: nil, segmentation: nil) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "consent-give-all":
            return [
                { cly.consent.giveAllConsents() },
                { cly.events.recordEvent("after_all_consents") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "consent-give-individual":
            return [
                { cly.consent.giveConsent(for: .sessions) },
                { cly.consent.giveConsent(for: .events) },
                { cly.events.recordEvent("after_event_consent") },
                { cly.consent.giveConsent(for: .viewTracking) },
                { _ = cly.views.startView("AfterViewConsent") },
                { cly.consent.giveConsent(for: [.userDetails, .location]) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "consent-remove-individual":
            return [
                { cly.consent.giveAllConsents() },
                { cly.events.recordEvent("while_consented") },
                { cly.consent.cancelConsent(for: .events) },
                { cly.events.recordEvent("after_events_cancelled") },
                { cly.consent.cancelConsent(for: .location) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "consent-remove-all":
            return [
                { cly.consent.giveAllConsents() },
                { cly.events.recordEvent("while_consented") },
                { cly.consent.cancelAllConsents() },
                { cly.events.recordEvent("after_all_cancelled") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "session-manual":
            return [
                { cly.sessions.beginSession() },
                { cly.events.recordEvent("during_manual_session") },
                { cly.sessions.updateSession() },
                { cly.sessions.endSession() },
                { cly.events.recordEvent("after_manual_session") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "session-manual-hybrid":
            return [
                { cly.sessions.beginSession() },
                { cly.events.recordEvent("during_hybrid_session") },
                { cly.sessions.updateSession() },
                { cly.sessions.endSession() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "session-auto-inert":
            return [
                { cly.sessions.beginSession() },
                { cly.sessions.updateSession() },
                { cly.sessions.endSession() },
                { cly.events.recordEvent("after_ignored_session_calls") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        // --- events -------------------------------------------------------

        case "event-basic":
            return [
                { cly.events.recordEvent("evt_plain") },
                { cly.events.recordEvent("evt_count", count: 3) },
                { cly.events.recordEvent("evt_sum", sum: 12.5) },
                { cly.events.recordEvent("evt_duration", duration: 4) },
                { cly.events.recordEvent("evt_count_sum", count: 2, sum: 7.25) },
                { cly.events.recordEvent("evt_seg", segmentation: ["colour": "red", "size": 42, "flag": true]) },
                { cly.events.recordEvent("evt_full", segmentation: ["a": "b"], count: 5, sum: 1.5, duration: 2) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "event-timed":
            return [
                { cly.events.startEvent("evt_timed") },
                { cly.events.endEvent("evt_timed", segmentation: ["outcome": "ok"], count: 1, sum: 0) },
                { cly.events.startEvent("evt_cancelled") },
                { cly.events.cancelEvent("evt_cancelled") },
                { cly.events.endEvent("evt_never_started") },
                { cly.events.startEvent("evt_started_twice") },
                { cly.events.startEvent("evt_started_twice") },
                { cly.events.endEvent("evt_started_twice") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "event-threshold":
            return [
                { cly.events.recordEvent("threshold_one") },
                { cly.events.recordEvent("threshold_two") },
                { cly.events.recordEvent("threshold_three") },
                { cly.events.recordEvent("threshold_four") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "event-limits":
            return [
                { cly.events.recordEvent("a_very_long_event_key_indeed") },
                { cly.events.recordEvent("lim_seg", segmentation: ["a_very_long_segmentation_key": "a_very_long_segmentation_value"]) },
                { cly.events.recordEvent("lim_count", segmentation: ["k1": "v1", "k2": "v2", "k3": "v3", "k4": "v4", "k5": "v5"]) },
                { cly.events.recordEvent("", segmentation: ["dropped": "yes"]) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        // --- views --------------------------------------------------------

        case "view-manual":
            return [
                { viewID = cly.views.startView("HomeView", segmentation: ["origin": "launch"]) },
                { cly.views.stopView(name: "HomeView", segmentation: ["reason": "navigated"]) },
                { viewID = cly.views.startView("ByIdView") },
                { cly.views.stopView(id: viewID ?? "") },
                { _ = cly.views.startAutoStoppedView("AutoStoppedA") },
                { _ = cly.views.startAutoStoppedView("AutoStoppedB") },
                { cly.views.stopView(name: "MissingView") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "view-pause-resume":
            return [
                { viewID = cly.views.startView("PausableView") },
                { cly.views.pauseView(id: viewID ?? "") },
                { cly.views.resumeView(id: viewID ?? "") },
                { cly.views.stopView(id: viewID ?? "") },
                { _ = cly.views.startView("LeftOpenOne") },
                { _ = cly.views.startView("LeftOpenTwo") },
                { cly.views.stopAllViews(segmentation: ["bulk": "yes"]) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "view-segmentation":
            return [
                { _ = cly.views.startView("WithConfigSegmentation") },
                { cly.views.setGlobalViewSegmentation(["tier": "gold"]) },
                { _ = cly.views.startView("WithGlobalSegmentation", segmentation: ["local": "yes"]) },
                { cly.views.updateGlobalViewSegmentation(["tier": "platinum", "extra": "added"]) },
                { cly.views.addSegmentation(toViewWithName: "WithGlobalSegmentation", segmentation: ["late": "addition"]) },
                { cly.views.stopAllViews() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        // --- user profile ---------------------------------------------------

        case "userprofile-predefined":
            return [
                { cly.userProfile.setProperty("name", value: "Parity Tester") },
                { cly.userProfile.setProperties(["email": "parity@example.com", "username": "parity", "organization": "Countly", "phone": "+10000000000", "gender": "M", "byear": 1990]) },
                { cly.userProfile.save() },
                { cly.userProfile.setProperty("name", value: "") },
                { cly.userProfile.save() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "userprofile-custom":
            return [
                { cly.userProfile.setProperties(["custom_string": "value", "custom_number": 11, "custom_bool": true]) },
                { cly.userProfile.setProperty("custom_cleared", value: "to_be_cleared") },
                { cly.userProfile.setProperty("custom_cleared", value: "") },
                { cly.userProfile.setProperties(["unsupported_type": Date(timeIntervalSince1970: 0)]) },
                { cly.userProfile.save() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "userprofile-modifiers":
            return [
                { cly.userProfile.setOnce("once_key", value: "first") },
                { cly.userProfile.setOnce("once_key", value: "second") },
                { cly.userProfile.increment("visits") },
                { cly.userProfile.incrementBy("score", value: 25) },
                { cly.userProfile.multiply("score", value: 2) },
                { cly.userProfile.max("highscore", value: 99) },
                { cly.userProfile.min("lowscore", value: 1) },
                { cly.userProfile.push("tags", value: "alpha") },
                { cly.userProfile.push("tags", value: "beta") },
                { cly.userProfile.pushUnique("unique_tags", value: "gamma") },
                { cly.userProfile.pull("tags", value: "alpha") },
                { cly.userProfile.save() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        // --- device id ------------------------------------------------------

        case "deviceid-merge":
            return [
                { cly.events.recordEvent("before_merge") },
                { cly.deviceID.changeWithMerge("parity-device-merged") },
                { cly.events.recordEvent("after_merge") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "deviceid-no-merge":
            return [
                { cly.events.recordEvent("before_no_merge") },
                { cly.deviceID.changeWithoutMerge("parity-device-fresh") },
                { cly.events.recordEvent("after_no_merge") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "deviceid-temporary":
            return [
                { cly.events.recordEvent("while_temporary") },
                { _ = cly.views.startView("TemporaryView") },
                { cly.requestQueue.attemptToSendStoredRequests() },
                { cly.deviceID.changeWithoutMerge("parity-device-real") },
                { cly.events.recordEvent("after_real_id") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        // --- crashes ---------------------------------------------------------

        case "crash-handled":
            return [
                { cly.crashes.recordError("ParityHandledError", isFatal: false, stackTrace: ["frame one", "frame two"], segmentation: nil) },
                { cly.crashes.recordException(NSException(name: .init("ParityException"), reason: "parity reason", userInfo: ["info": "value"]), isFatal: false, stackTrace: ["frame three"], segmentation: nil) },
                { cly.crashes.recordError("ParityFatalError", isFatal: true, stackTrace: ["fatal frame"], segmentation: nil) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "crash-breadcrumbs":
            return [
                { cly.crashes.addCrashBreadcrumb("breadcrumb one") },
                { cly.crashes.addCrashBreadcrumb("breadcrumb two") },
                { cly.crashes.addCrashBreadcrumb("breadcrumb three") },
                { cly.crashes.recordError("WithBreadcrumbs", isFatal: false, stackTrace: nil, segmentation: nil) },
                { cly.crashes.clearCrashBreadcrumbs() },
                { cly.crashes.recordError("WithoutBreadcrumbs", isFatal: false, stackTrace: nil, segmentation: nil) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "crash-segmentation":
            return [
                { cly.crashes.recordError("GlobalSegmentationOnly", isFatal: false, stackTrace: nil, segmentation: nil) },
                // The Objective-C SDK has no runtime setter for this, so its twin
                // step is a log line. Kept here because it is a real difference in
                // the surface, not in the behavior of the shared steps.
                { NSLog("[SCENARIO] this SDK has a runtime crash segmentation setter, the baseline does not") },
                { cly.crashes.recordException(NSException(name: .init("MergedSegmentation"), reason: "reason", userInfo: nil), isFatal: false, stackTrace: nil, segmentation: ["per_call": "override"]) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        // --- remote config ---------------------------------------------------

        case "rc-download":
            return [
                { cly.remoteConfig.downloadKeys { result, error, full, values in
                    NSLog("[SCENARIO] downloadKeys result: \(result), full: \(full), count: \(values.count)") } },
                { NSLog("[SCENARIO] getValue welcome_text: \(String(describing: cly.remoteConfig.getValue("welcome_text").value))") },
                { NSLog("[SCENARIO] getValue missing_key: \(String(describing: cly.remoteConfig.getValue("missing_key").value))") },
                { NSLog("[SCENARIO] getAllValues count: \(cly.remoteConfig.getAllValues().count)") },
                { cly.remoteConfig.downloadSpecificKeys(["welcome_text"]) },
                { cly.remoteConfig.downloadOmittingKeys(["flag"]) },
                { cly.remoteConfig.clearAll() },
                { NSLog("[SCENARIO] after clearAll count: \(cly.remoteConfig.getAllValues().count)") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "rc-ab":
            return [
                { cly.remoteConfig.downloadKeys() },
                { cly.remoteConfig.testingDownloadVariantInformation { _, _ in
                    NSLog("[SCENARIO] variants: \(cly.remoteConfig.testingGetAllVariants())") } },
                { cly.remoteConfig.testingDownloadExperimentInformation { _, _ in
                    NSLog("[SCENARIO] experiments: \(cly.remoteConfig.testingGetAllExperimentInfo().count)") } },
                { cly.remoteConfig.enrollIntoABTests(forKeys: ["welcome_text"]) },
                { cly.remoteConfig.exitABTests(forKeys: ["welcome_text"]) },
                { NSLog("[SCENARIO] getValueAndEnroll: \(String(describing: cly.remoteConfig.getValueAndEnroll("welcome_text").value))") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        // --- feedback ---------------------------------------------------------

        case "feedback-list":
            return [
                { cly.feedback.getAvailableFeedbackWidgets { widgets, error in
                    NSLog("[SCENARIO] widgets: \(widgets?.count ?? 0), error: \(String(describing: error))") } },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "feedback-record":
            return [
                { cly.feedback.recordRatingWidget(id: "widget_rating_1", rating: 4, email: "parity@example.com", comment: "good", userCanBeContacted: true) },
                { cly.feedback.recordRatingWidget(id: "widget_rating_2", rating: 1, email: nil, comment: nil, userCanBeContacted: false) },
                { cly.feedback.recordRatingWidget(id: "", rating: 3, email: nil, comment: nil, userCanBeContacted: false) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        // --- everything else ---------------------------------------------------

        case "attribution":
            return [
                { cly.attribution.recordDirectAttribution(campaignType: "countly", campaignData: "{\"cid\":\"campaign1\",\"cuid\":\"user1\"}") },
                { cly.attribution.recordDirectAttribution(campaignType: "countly", campaignData: "{\"cid\":\"campaign_no_user\"}") },
                { cly.attribution.recordDirectAttribution(campaignType: "unsupported", campaignData: "{\"cid\":\"nope\"}") },
                { cly.attribution.recordIndirectAttribution(["idfa": "PARITY-IDFA"]) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "apm":
            return [
                { cly.performance.recordNetworkTrace("parity_network", requestPayloadSize: 128, responsePayloadSize: 256, responseStatusCode: 200, startTime: 1700000000000, endTime: 1700000000500) },
                { cly.performance.startCustomTrace("parity_trace") },
                { cly.performance.endCustomTrace("parity_trace", metrics: ["steps": 3]) },
                { cly.performance.startCustomTrace("parity_cancelled") },
                { cly.performance.cancelCustomTrace("parity_cancelled") },
                { cly.performance.endCustomTrace("parity_never_started") },
                { cly.performance.appLoadingFinished() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "location":
            return [
                { cly.location.recordLocation(CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060), city: "New York", isoCountryCode: "US", ipAddress: "10.0.0.2") },
                { cly.location.disableLocationInfo() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "queue-ops":
            return [
                { cly.events.recordEvent("queued_one") },
                { cly.events.recordEvent("queued_two") },
                { cly.requestQueue.flushQueues() },
                { cly.events.recordEvent("after_flush") },
                { cly.requestQueue.replaceAllAppKeysInQueueWithCurrentAppKey() },
                { cly.requestQueue.removeDifferentAppKeysFromQueue() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "direct-request":
            return [
                { cly.recordMetrics(["_custom_metric": "custom_value"]) },
                { cly.addDirectRequest(["custom_key": "custom_value", "device_id": "should_be_stripped"]) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "sbs-restrictive":
            return [
                { cly.events.recordEvent("under_restrictive_settings") },
                { _ = cly.views.startView("UnderRestrictiveSettings") },
                { cly.crashes.recordError("UnderRestrictiveSettings", isFatal: false, stackTrace: nil, segmentation: nil) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "salt":
            return [
                { cly.events.recordEvent("salted_event") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        // --- automatic view tracking ------------------------------------------

        case "view-auto":
            return [
                { presentTitled("AutoViewOne") },
                { presentTitled("AutoViewTwo") },
                { dismissTop() },
                { dismissTop() },
                { presentTitled("AutoViewThree") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "view-auto-exclusion":
            return [
                { presentTitled("AutoViewExcluded") },
                { presentTitled("AutoViewIncluded") },
                { dismissTop() },
                { dismissTop() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        // --- automatic sessions -------------------------------------------------

        case "session-auto-update":
            return [
                { cly.events.recordEvent("before_first_tick") },
                { NSLog("[SCENARIO] waiting for the session update timer") },
                { NSLog("[SCENARIO] still waiting") },
                { NSLog("[SCENARIO] still waiting") },
            ]

        case "session-auto-background":
            return [
                { cly.events.recordEvent("before_background") },
                { NSLog("[SCENARIO] waiting for the harness to background the app") },
            ]

        // --- foreground and background ------------------------------------------

        case "lifecycle-background":
            return [
                { cly.events.recordEvent("before_background") },
                { cly.userProfile.setProperty("name", value: "Before Background") },
                { NSLog("[SCENARIO] waiting for the harness to background the app") },
            ]

        case "lifecycle-events-background":
            return [
                { cly.events.recordEvent("before_background") },
                { NSLog("[SCENARIO] waiting for the harness to background the app") },
            ]

        case "lifecycle-views-background":
            return [
                { presentTitled("ViewAcrossBackground") },
                { NSLog("[SCENARIO] waiting for the harness to background the app") },
            ]

        // --- request ordering ----------------------------------------------------

        case "ordering-profile-events":
            return [
                // A user property set and then an event recorded. The server applies
                // requests in the order it receives them, so an event that lands
                // before the property is attributed to a user without it yet.
                { cly.userProfile.setProperty("name", value: "Ordered Tester") },
                { cly.userProfile.setProperty("tier", value: "gold") },
                { cly.events.recordEvent("after_profile_change") },
                { cly.requestQueue.attemptToSendStoredRequests() },
                // And the reverse: a property set with an event already pending.
                { cly.events.recordEvent("before_profile_change") },
                { cly.userProfile.setProperty("tier", value: "platinum") },
                { cly.userProfile.save() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "migration-resume-cache":
            return [
                { NSLog("[SCENARIO] device ID inherited: [\(cly.deviceID.current ?? "none")]") },
                { let values = cly.remoteConfig.getAllValues()
                  NSLog("[SCENARIO] RC values read from the inherited cache: \(values.count) -> \(values.keys.sorted())")
                  NSLog("[SCENARIO] welcome_text = \(String(describing: cly.remoteConfig.getValue("welcome_text").value))") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "migration-resume":
            return [
                { NSLog("[SCENARIO] device ID inherited: [\(cly.deviceID.current ?? "none")], type: [\(String(describing: cly.deviceID.type))]") },
                { cly.requestQueue.attemptToSendStoredRequests() },
                { NSLog("[SCENARIO] queued requests remaining: \(cly.requestQueue.count)") },
                { cly.events.recordEvent("recorded_after_migration") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]


        // =====================================================================
        // Scenarios added for the Android comparison. Where this SDK lacks the
        // API its step logs the fact and only drains the queue, so the capture
        // shows the gap.
        // =====================================================================

        case "event-past":
            return [
                { NSLog("[SCENARIO] this SDK has no recordPastEvent") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "event-types":
            return [
                { cly.events.recordEvent("evt_types", segmentation: ["str": "s", "int": 1, "double": 1.5, "bool": true, "long": 123456789012, "null": NSNull(), "list": [1, 2], "map": [String: Any](), "empty": ""]) },
                { cly.events.recordEvent("evt_negative", count: -3, sum: -1.5, duration: -2) },
                { cly.events.recordEvent("evt_zero_count", count: 0) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "consent-feature-group":
            return [
                { NSLog("[SCENARIO] this SDK has no consent feature groups, giving the members individually") },
                { cly.consent.giveConsent(for: [.events, .viewTracking]) },
                { cly.events.recordEvent("after_group_consent") },
                { cly.consent.cancelConsent(for: [.events, .viewTracking]) },
                { cly.events.recordEvent("after_group_revoked") },
                { cly.consent.giveConsent(for: .sessions) },
                { NSLog("[SCENARIO] getConsent(sessions): \(cly.consent.hasConsent(for: .sessions))") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "apm-network-manual":
            return [
                { NSLog("[SCENARIO] this SDK has no startNetworkRequest / endNetworkRequest") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "apm-fg-bg-manual":
            return [
                { NSLog("[SCENARIO] this SDK has no manual foreground / background APM triggers") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "apm-auto":
            return [
                { NSLog("[SCENARIO] app start trace expected from init, waiting for the harness to background the app") },
            ]

        case "feedback-manual":
            var widget: CountlyFeedbackWidget?
            return [
                { cly.feedback.getAvailableFeedbackWidgets { widgets, _ in
                    widget = widgets?.first
                    NSLog("[SCENARIO] widgets: \(widgets?.count ?? 0), first: \(widget?.id ?? "none")") } },
                { widget?.getWidgetData { data, error in
                    NSLog("[SCENARIO] widget data: \(String(describing: data)), error: \(String(describing: error))") } },
                { widget?.recordResult(["rating": 9, "comment": "manual"]) },
                { widget?.recordResult(nil) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "feedback-present":
            return [
                { cly.feedback.presentNPS() },
                { NSLog("[SCENARIO] waiting for the widget to load") },
                { NSLog("[SCENARIO] still waiting") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "storage-explicit":
            return [
                { cly.events.recordEvent("explicit_one") },
                { cly.events.recordEvent("explicit_two") },
                { NSLog("[SCENARIO] this SDK has no explicit storage mode") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "queue-post-forced":
            return [
                { NSLog("[SCENARIO] alwaysUsePOST set at init") },
                { cly.events.recordEvent("posted_event") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "queue-headers":
            return [
                { cly.events.recordEvent("with_init_header") },
                { cly.requestQueue.attemptToSendStoredRequests() },
                { cly.addCustomNetworkRequestHeaders(["X-Parity-Runtime": "two"]) },
                { cly.events.recordEvent("with_runtime_header") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "content-zone":
            return [
                { cly.content.enterContentZone() },
                { cly.content.refreshContentZone() },
                { cly.content.exitContentZone() },
                { cly.content.refreshContentZone() },
                { cly.content.previewContent("preview_id") },
                { cly.content.enterContentZone() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "deviceid-set":
            return [
                { NSLog("[SCENARIO] before: \(cly.deviceID.current ?? "nil") / \(String(describing: cly.deviceID.type))") },
                { cly.deviceID.setID("parity-device-set") },
                { NSLog("[SCENARIO] after: \(cly.deviceID.current ?? "nil") / \(String(describing: cly.deviceID.type))") },
                { cly.events.recordEvent("after_set_id") },
                { cly.deviceID.setID(cly.deviceID.current ?? "") },
                { cly.deviceID.setID("") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "deviceid-clear-stored":
            return [
                { NSLog("[SCENARIO] generated: \(cly.deviceID.current ?? "nil") / \(String(describing: cly.deviceID.type))") },
                { cly.events.recordEvent("with_generated_id") },
                { cly.requestQueue.attemptToSendStoredRequests() },
                { NSLog("[SCENARIO] waiting for the harness to kill and relaunch the app") },
            ]

        case "init-user-properties":
            return [
                { cly.events.recordEvent("after_init_properties") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "init-metric-override":
            return [
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "init-all-consents":
            return [
                { cly.events.recordEvent("with_init_consents") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "init-consent-enabled":
            return [
                { cly.events.recordEvent("with_partial_consents") },
                { _ = cly.views.startView("NoViewConsent") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "sbs-listing-filters":
            return [
                { cly.content.enterContentZone() },
                { cly.events.recordEvent("blocked_event") },
                { cly.events.recordEvent("allowed_event", segmentation: ["blocked_seg": "x", "kept_seg": "y"]) },
                { cly.events.recordEvent("evt_seg_filtered", segmentation: ["local_blocked": "x", "kept_seg": "y"]) },
                { cly.userProfile.setProperty("blocked_prop", value: "x") },
                { cly.userProfile.setProperty("kept_prop", value: "y") },
                { cly.userProfile.setProperty("third_prop", value: "z") },
                { cly.userProfile.save() },
                { cly.events.recordEvent("journey_event") },
                { _ = cly.views.startView("JourneyView") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "sbs-auto-off":
            return [
                { cly.events.recordEvent("under_auto_off") },
                { presentTitled("AutoViewOne") },
                { _ = cly.views.startView("ManualUnderAutoOff") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "sbs-consent-required":
            return [
                { cly.events.recordEvent("server_requires_consent") },
                { cly.consent.giveAllConsents() },
                { cly.events.recordEvent("after_giving_consent") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "crash-unhandled":
            return [
                { cly.crashes.addCrashBreadcrumb("about to crash") },
                { cly.events.recordEvent("before_crash") },
                { NSException(name: .init("ParityUnhandled"), reason: "ParityUnhandled", userInfo: nil).raise() },
            ]

        case "crash-filter":
            return [
                { cly.crashes.recordError("DroppedByFilter", isFatal: false, stackTrace: nil, segmentation: nil) },
                { cly.crashes.recordError("KeptByFilter", isFatal: false, stackTrace: nil, segmentation: nil) },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "views-previous-name":
            return [
                { _ = cly.views.startView("FirstView") },
                { cly.views.stopView(name: "FirstView") },
                { _ = cly.views.startView("SecondView") },
                { cly.events.recordEvent("first_event") },
                { cly.events.recordEvent("second_event") },
                { cly.views.stopAllViews() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "views-visibility":
            return [
                { _ = cly.views.startView("VisibleView") },
                { cly.events.recordEvent("visible_event") },
                { cly.views.stopAllViews() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "location-init-disabled":
            return [
                { cly.events.recordEvent("with_location_disabled") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "content-rotate":
            // A full-screen content is shown, the interface is rotated to landscape
            // and back, and the log shows how the page is re-laid out each time.
            var rotateSteps: [() -> Void] = [{ cly.content.enterContentZone() }]
            rotateSteps += Array(repeating: { NSLog("[SCENARIO] waiting for the content") }, count: 12)
            rotateSteps.append { rotate(.landscapeRight) }
            rotateSteps += Array(repeating: { NSLog("[SCENARIO] landscape") }, count: 12)
            rotateSteps.append { rotate(.portrait) }
            rotateSteps += Array(repeating: { NSLog("[SCENARIO] portrait") }, count: 10)
            return rotateSteps

        case "orientation":
            return [
                { NSLog("[SCENARIO] the harness cannot rotate the simulator, Android only") },
                { NSLog("[SCENARIO] still waiting") },
                { NSLog("[SCENARIO] still waiting") },
                { NSLog("[SCENARIO] still waiting") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "multi-instance":
            return [
                { let second = CountlyConfig()
                  second.appKey = "parity_app_key_2"
                  second.host = "http://localhost:8080"
                  second.deviceID = "parity-device-2"
                  second.enableDebug = true
                  second.updateSessionPeriod = 60
                  Countly.instance(named: "second").start(with: second) },
                { cly.events.recordEvent("on_default") },
                { Countly.instance(named: "second").events.recordEvent("on_second") },
                { NSLog("[SCENARIO] instances: \(Countly.listInstances())") },
                { cly.requestQueue.attemptToSendStoredRequests() },
                { Countly.instance(named: "second").requestQueue.attemptToSendStoredRequests() },
                { Countly.instance(named: "second").halt() },
                { cly.events.recordEvent("after_second_halted") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "halt":
            return [
                { cly.events.recordEvent("before_halt") },
                { cly.requestQueue.attemptToSendStoredRequests() },
                { cly.halt() },
                { cly.events.recordEvent("after_halt") },
                { NSLog("[SCENARIO] isStarted: \(cly.isStarted)") },
            ]

        case "rc-id-change":
            return [
                { cly.remoteConfig.downloadKeys() },
                { NSLog("[SCENARIO] before change: \(describe(cly.remoteConfig.getValue("welcome_text")))") },
                { cly.deviceID.changeWithoutMerge("parity-device-rc") },
                { NSLog("[SCENARIO] after no-merge change: \(describe(cly.remoteConfig.getValue("welcome_text")))") },
                { cly.deviceID.changeWithMerge("parity-device-rc-merged") },
                { NSLog("[SCENARIO] after merge change: \(describe(cly.remoteConfig.getValue("welcome_text")))") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "userprofile-picture":
            return [
                { cly.userProfile.setProperty("picture", value: "https://example.com/parity.png") },
                { cly.userProfile.save() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        case "connection-test":
            return [
                { NSLog("[SCENARIO] this SDK has no connection test") },
                { NSLog("[SCENARIO] still waiting") },
                { NSLog("[SCENARIO] still waiting") },
                { NSLog("[SCENARIO] still waiting") },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]

        default:
            NSLog("[SCENARIO] unknown scenario: \(scenario)")
            return []
        }
    }

    private static func describe(_ data: CountlyRCData) -> String {
        "\(String(describing: data.value)) (isCurrentUsersData: \(data.isCurrentUsersData))"
    }

    /// Rotates the interface without touching the simulator: the scene is asked
    /// for the orientation the way an application locking a screen would ask.
    private static func rotate(_ orientation: UIInterfaceOrientationMask) {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            NSLog("[SCENARIO] no active scene to rotate")
            return
        }
        NSLog("[SCENARIO] rotating, landscape: \(orientation == .landscapeRight)")
        scene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation)) { error in
            NSLog("[SCENARIO] rotation was refused: \(error.localizedDescription)")
        }
        scene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
    }

    // MARK: - Runner

    static func run() {
        let scenario = name
        let list = steps(for: scenario)

        NSLog("[SCENARIO] starting [\(scenario)], stepCount: \(list.count)")
        step(list, 0, gap: 0.5)
    }

    private static func step(_ steps: [() -> Void], _ index: Int, gap: TimeInterval) {
        guard index < steps.count else {
            NSLog("[SCENARIO] done, stepCount: \(steps.count)")
            return
        }

        NSLog("[SCENARIO] step \(index + 1)/\(steps.count)")
        steps[index]()

        DispatchQueue.main.asyncAfter(deadline: .now() + gap) {
            step(steps, index + 1, gap: gap)
        }
    }
}
