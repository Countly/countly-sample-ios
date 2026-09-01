// SDKSetupView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// Where the sample points and what it switches on at init.
///
/// Configuration is read once, at `start(with:)`, so nothing here can take effect
/// while the application is running. Everything is written to `UserDefaults` and
/// picked up on the next launch, except the host and app key, which the SDK can
/// also be told about mid-run.
struct SDKSetupView: View {

    @AppStorage(SDKSetup.Key.host) private var host = ""
    @AppStorage(SDKSetup.Key.appKey) private var appKey = ""

    @AppStorage(SDKSetup.Key.requiresConsent) private var requiresConsent = false
    @AppStorage(SDKSetup.Key.enableAllConsents) private var enableAllConsents = true
    @AppStorage(SDKSetup.Key.manualSessions) private var manualSessions = false
    @AppStorage(SDKSetup.Key.crashReporting) private var crashReporting = true
    @AppStorage(SDKSetup.Key.pushNotifications) private var pushNotifications = false
    @AppStorage(SDKSetup.Key.logLevel) private var logLevel = CountlyLogLevel.debug.rawValue
    @AppStorage(SDKSetup.Key.temporaryDeviceID) private var temporaryDeviceID = false
    @AppStorage(SDKSetup.Key.customDeviceID) private var customDeviceID = ""
    @AppStorage(SDKSetup.Key.rcAutomaticTriggers) private var rcAutomaticTriggers = false
    @AppStorage(SDKSetup.Key.contentZoneInterval) private var contentZoneInterval = 30
    @AppStorage(SDKSetup.Key.apmAppStart) private var apmAppStart = false
    @AppStorage(SDKSetup.Key.apmForegroundBackground) private var apmForegroundBackground = false
    @AppStorage(SDKSetup.Key.apmManualAppLoaded) private var apmManualAppLoaded = false
    @AppStorage(SDKSetup.Key.behaviorSettings) private var behaviorSettings = ""
    @AppStorage(SDKSetup.Key.pinBehaviorSettings) private var pinBehaviorSettings = false

    var body: some View {
        FeatureList {
            Section {
                LabeledField("Server URL", text: $host, placeholder: SDKSetup.placeholderHost)
                LabeledField("App key", text: $appKey, placeholder: SDKSetup.placeholderAppKey)
                Button("Apply to the Running SDK") { applyNow() }
                Button("Print What is in Use") {
                    AppLog.shared.log("host: \(SDKSetup.host), app key: \(SDKSetup.appKey), started: \(Countly.shared.isStarted), SDK v\(SDKIdentity.version) as \(SDKIdentity.name)")
                }
            } header: {
                Text("Server")
            } footer: {
                FootnoteText("Left empty the sample uses \(SDKSetup.placeholderHost) and \(SDKSetup.placeholderAppKey), which reach nothing, so it builds and runs with nothing configured. Applying now changes the running instance; the values are read again at the next launch either way.")
            }

            Section {
                Toggle("Require consent", isOn: $requiresConsent)
                Toggle("Grant every consent at init", isOn: $enableAllConsents)
                Toggle("Manual session handling", isOn: $manualSessions)
                Toggle("Crash reporting", isOn: $crashReporting)
                Toggle("Push notifications", isOn: $pushNotifications)
            } header: {
                Text("Features at init")
            } footer: {
                FootnoteText("Crash reporting and push are opt in; everything else the SDK does is on by default. These are read at init only, so relaunch after changing one.")
            }

            Section {
                Picker("Internal log level", selection: $logLevel) {
                    ForEach(CountlyLogLevel.allCases, id: \.rawValue) { level in
                        Text(String(describing: level)).tag(level.rawValue)
                    }
                }
                .pickerStyle(.menu)
            } header: {
                Text("Logging")
            } footer: {
                FootnoteText("The sample attaches a logger delegate, so every line the SDK emits at or below this level shows up in the pane at the bottom of the window as well as in the console.")
            }

            Section {
                LabeledField("Custom device ID", text: $customDeviceID, placeholder: "left empty the SDK generates one")
                Toggle("Start in temporary device ID mode", isOn: $temporaryDeviceID)
            } header: {
                Text("Device ID")
            }

            Section {
                Toggle("Automatic remote config triggers", isOn: $rcAutomaticTriggers)
            } header: {
                Text("Remote config")
            } footer: {
                FootnoteText("Downloads at init and after every device ID change, rather than only when the Remote Config screen asks.")
            }

            Section {
                Stepper("Content zone interval: \(contentZoneInterval)s", value: $contentZoneInterval, in: 5...600, step: 5)
            } header: {
                Text("Content")
            } footer: {
                FootnoteText("How often the SDK asks the server for content while the zone is entered.")
            }

            Section {
                Toggle("App start time tracking", isOn: $apmAppStart)
                Toggle("Foreground and background tracking", isOn: $apmForegroundBackground)
                Toggle("Manual app loaded trigger", isOn: $apmManualAppLoaded)
            } header: {
                Text("Performance monitoring")
            } footer: {
                FootnoteText("Foreground and background traces follow NSApplication activation on macOS, so they open and close as the window gains and loses focus.")
            }

            Section {
                LabeledField("Behaviour settings", text: $behaviorSettings, placeholder: "{}")
                Toggle("Ignore what the server sends", isOn: $pinBehaviorSettings)
            } header: {
                Text("SDK behaviour settings")
            } footer: {
                FootnoteText("A JSON object the SDK treats as though the server had sent it. Pinning them makes the developer supplied value win over every later server response, which is what a reproducible test run needs.")
            }

            Section {
                Button("Reset Everything on this Screen", role: .destructive) { reset() }
            } footer: {
                FootnoteText("Clears the stored setup, putting the sample back on the placeholder server at the next launch. What the SDK already wrote to disk, such as the device ID and the request queue, is left alone.")
            }
        }
    }

    private func applyNow() {
        let trimmedHost = host.trimmingCharacters(in: .whitespaces)
        let trimmedAppKey = appKey.trimmingCharacters(in: .whitespaces)

        if !trimmedHost.isEmpty { Countly.shared.setNewHost(trimmedHost) }
        if !trimmedAppKey.isEmpty { Countly.shared.setNewAppKey(trimmedAppKey) }

        AppLog.shared.log("applied host: \(trimmedHost.isEmpty ? "unchanged" : trimmedHost), app key: \(trimmedAppKey.isEmpty ? "unchanged" : trimmedAppKey)")
    }

    private func reset() {
        host = ""
        appKey = ""
        requiresConsent = false
        enableAllConsents = true
        manualSessions = false
        crashReporting = true
        pushNotifications = false
        logLevel = CountlyLogLevel.debug.rawValue
        temporaryDeviceID = false
        customDeviceID = ""
        rcAutomaticTriggers = false
        contentZoneInterval = 30
        apmAppStart = false
        apmForegroundBackground = false
        apmManualAppLoaded = false
        behaviorSettings = ""
        pinBehaviorSettings = false
        AppLog.shared.log("setup reset, relaunch to start against the placeholder server again")
    }
}
