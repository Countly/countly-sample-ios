// InitView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// The whole of `CountlyConfig`, plus the lifecycle calls that act on the instance
/// it configures.
///
/// The SDK is not started at launch. It is started from here, which is what makes
/// every option on this screen testable: an option applied at init can only be
/// tried by choosing it before init happens.
///
/// Settings with no effect on macOS are shown disabled with a note rather than
/// hidden, because seeing the whole surface, and where it stops, is the point.
struct InitView: View {

    @ObservedObject private var model = InitModel.shared

    var body: some View {
        FeatureList {
            statusSection
            coreSection
            featuresSection
            flagsSection
            tuningSection
            limitsSection
            contentSection
            apmSection
            crashesSection
            initOnlySection
            behaviourSection
            lifecycleSection
        }
        .onAppear { model.refreshStatus() }
    }

    // MARK: - Status

    private var statusSection: some View {
        Section {
            HStack(spacing: 8) {
                Circle()
                    .fill(model.isStarted ? Color.green : Color.secondary)
                    .frame(width: 9, height: 9)
                Text(model.isStarted
                     ? "Started · instance \(model.startedInstanceName) · device \(model.startedDeviceID.isEmpty ? "?" : model.startedDeviceID)"
                     : "Not started")
                    .font(.callout)
                Spacer()
                Button("Refresh") { model.refreshStatus() }
                    .buttonStyle(.borderless)
                    .font(.caption)
            }
        } header: {
            Text("Status")
        } footer: {
            FootnoteText("Nothing is recorded and every other screen is a logged no-op until the SDK is initialized below.")
        }
    }

    // MARK: - Core and identity

    private var coreSection: some View {
        Section {
            LabeledField("Server URL", text: $model.host, placeholder: AppContext.defaultHost)
            LabeledField("App key", text: $model.appKey, placeholder: AppContext.defaultAppKey)
            LabeledField("Instance name", text: $model.instanceName, placeholder: "empty means the default instance")
            LabeledField("Custom device ID", text: $model.deviceID, placeholder: "empty means the SDK generates one")
            LabeledField("App version", text: $model.appVersion, placeholder: "read from the bundle")
            LabeledField("Tampering salt", text: $model.secretSalt, placeholder: "secretSalt, empty means no checksum")
            LabeledField("Pinned certificates", text: $model.pinnedCertificates, placeholder: "comma separated .cer names in the bundle")

            Picker("Internal log level", selection: $model.logLevel) {
                ForEach(CountlyLogLevel.allCases, id: \.self) { level in
                    Text(level.label).tag(level)
                }
            }
            .pickerStyle(.menu)

            Toggle("Enable debug logging", isOn: $model.enableDebug)
        } header: {
            Text("Core and identity")
        } footer: {
            FootnoteText("The Swift SDK has no application version setter: the app version is a device metric, so this field is applied as a custom metric override of \(MetricKey.appVersion). Naming the instance gives it its own storage, device ID, request queue and consent state, and every feature screen then drives that instance.")
        }
    }

    // MARK: - Features

    private var featuresSection: some View {
        Section {
            ForEach(CountlyFeature.allCases, id: \.self) { feature in
                Toggle(String(describing: feature), isOn: binding(for: feature))
            }
        } header: {
            Text("Features")
        } footer: {
            FootnoteText("Both of these are opt in: the SDK does nothing for crashes or push unless the feature was requested at init. Everything else the SDK does needs no opting in.")
        }
    }

    private func binding(for feature: CountlyFeature) -> Binding<Bool> {
        Binding(
            get: { model.features.contains(feature) },
            set: { on in
                if on { model.features.insert(feature) } else { model.features.remove(feature) }
            }
        )
    }

    // MARK: - Flags

    private var flagsSection: some View {
        Section {
            Toggle("requiresConsent", isOn: $model.requiresConsent)
            Toggle("enableAllConsents", isOn: $model.enableAllConsents)
            Toggle("manualSessionHandling", isOn: $model.manualSessionHandling)
            Toggle("enableManualSessionControlHybridMode", isOn: $model.enableManualSessionControlHybridMode)
            Toggle("alwaysUsePOST", isOn: $model.alwaysUsePOST)
            Toggle("disableLocation", isOn: $model.disableLocation)
            Toggle("temporaryDeviceIDMode", isOn: $model.temporaryDeviceIDMode)
            Toggle("resetStoredDeviceID", isOn: $model.resetStoredDeviceID)
            Toggle("enableRemoteConfigAutomaticTriggers", isOn: $model.enableRemoteConfigAutomaticTriggers)
            Toggle("enableRemoteConfigValueCaching", isOn: $model.enableRemoteConfigValueCaching)
            Toggle("enrollABOnRCDownload", isOn: $model.enrollABOnRCDownload)
            Toggle("disableBackoffMechanism", isOn: $model.disableBackoffMechanism)
            Toggle("disableSDKBehaviorSettingsUpdates", isOn: $model.disableSDKBehaviorSettingsUpdates)
            Toggle("shouldIgnoreTrustCheck", isOn: $model.shouldIgnoreTrustCheck)
            Toggle("disableViewRestartForManualRecording", isOn: $model.disableViewRestartForManualRecording)

            Toggle("sendPushTokenAlways", isOn: $model.sendPushTokenAlways)
            Toggle("disableAutomaticPushHandling", isOn: $model.disableAutomaticPushHandling)
            Toggle("doNotShowAlertForNotifications", isOn: $model.doNotShowAlertForNotifications)

            Toggle("experimental.enablePreviousNameRecording", isOn: $model.enablePreviousNameRecording)
            Toggle("experimental.enableVisibilityTracking", isOn: $model.enableVisibilityTracking)

            VStack(alignment: .leading, spacing: 2) {
                Toggle("enableAutomaticViewTracking", isOn: $model.enableAutomaticViewTracking)
                    .disabled(true)
                FootnoteText("No effect on macOS: the tracker is a UIViewController swizzle guarded to iOS and tvOS, and the server config does not even seed the flag here.")
            }
            VStack(alignment: .leading, spacing: 2) {
                Toggle("enableOrientationTracking", isOn: $model.enableOrientationTracking)
                    .disabled(true)
                FootnoteText("No effect on macOS: the orientation event is recorded only under os(iOS).")
            }
        } header: {
            Text("Flags")
        }
    }

    // MARK: - Tuning

    private var tuningSection: some View {
        Section {
            TuningField("eventSendThreshold", text: $model.eventSendThreshold, default: "100")
            TuningField("updateSessionPeriod (s)", text: $model.updateSessionPeriod, default: "60")
            TuningField("storedRequestsLimit", text: $model.storedRequestsLimit, default: "1000")
            TuningField("requestDropAgeHours", text: $model.requestDropAgeHours, default: "0, meaning never")
            TuningField("requestTimeoutDuration (s)", text: $model.requestTimeoutDuration, default: "30")
        } header: {
            Text("Tuning")
        } footer: {
            FootnoteText("An empty field leaves the SDK's own default alone; the greyed value is what that default is. eventSendThreshold is the one deliberate override on this screen, pre-filled to 1 so every event leaves the device immediately and the request log stays readable.")
        }
    }

    private var limitsSection: some View {
        Section {
            TuningField("maxKeyLength", text: $model.maxKeyLength, default: "128")
            TuningField("maxValueSize", text: $model.maxValueSize, default: "256")
            TuningField("maxValueSizePicture", text: $model.maxValueSizePicture, default: "4096")
            TuningField("maxSegmentationValues", text: $model.maxSegmentationValues, default: "100")
            TuningField("maxBreadcrumbCount", text: $model.maxBreadcrumbCount, default: "100")
            TuningField("maxStackTraceLineLength", text: $model.maxStackTraceLineLength, default: "200")
            TuningField("maxStackTraceLinesPerThread", text: $model.maxStackTraceLinesPerThread, default: "30")
        } header: {
            Text("sdkInternalLimits")
        } footer: {
            FootnoteText("The Custom Events screen has buttons that deliberately exceed these, so lowering one here and pressing those shows the truncation in the log.")
        }
    }

    // MARK: - Sub-configs

    private var contentSection: some View {
        Section {
            TuningField("zoneTimerInterval (s)", text: $model.contentZoneTimerInterval, default: "30, minimum 15")
            Picker("webViewDisplayOption", selection: $model.contentDisplayOption) {
                Text("immersive").tag(WebViewDisplayOption.immersive)
                Text("safeArea").tag(WebViewDisplayOption.safeArea)
            }
            .pickerStyle(.menu)
            Toggle("enableContentReloadOnStall", isOn: $model.contentReloadOnStall)
            TuningField("contentReloadOnStallTimeout (ms)", text: $model.contentReloadOnStallTimeout, default: "1000")
            Toggle("disableZoom", isOn: $model.contentDisableZoom)
            Toggle("disableRotation", isOn: $model.contentDisableRotation)
        } header: {
            Text("content")
        } footer: {
            FootnoteText("An interval at or below the 15 second minimum is ignored and the previous value kept. The global content callback and the URL handler are always installed by the sample, so both land in the log.")
        }
    }

    private var apmSection: some View {
        Section {
            Toggle("enableAppStartTimeTracking", isOn: $model.apmAppStartTimeTracking)
            Toggle("enableForegroundBackgroundTracking", isOn: $model.apmForegroundBackgroundTracking)
            Toggle("enableManualAppLoadedTrigger", isOn: $model.apmManualAppLoadedTrigger)
            TuningField("appStartTimestampOverride (ms)", text: $model.apmAppStartTimestampOverride, default: "0, meaning no override")
        } header: {
            Text("apm")
        } footer: {
            FootnoteText("Foreground and background traces follow NSApplication activation on macOS, so they open and close as this window gains and loses focus.")
        }
    }

    private var crashesSection: some View {
        Section {
            Toggle("crashFilterCallback dropping names containing 'Ignored'", isOn: $model.crashFilterIgnored)
            Toggle("crashSegmentation [\"SomeOtherSDK\": \"v3.4.5\"]", isOn: $model.crashSegmentation)
        } header: {
            Text("crashes")
        } footer: {
            FootnoteText("The filter runs before a report is queued and logs what it decided, so the Crash Reporting screen shows it working.")
        }
    }

    private var initOnlySection: some View {
        Section {
            Toggle("remoteConfigRegisterGlobalCallback", isOn: $model.rcGlobalCallback)
            Toggle("shouldSendCrashReportCallback dropping reports named 'Ignored'", isOn: $model.shouldSendCrashReportCallback)
            Toggle("providedUserProperties [\"tier\": \"gold\", \"source\": \"macOS sample\"]", isOn: $model.providedUserProperties)
        } header: {
            Text("Init-only callbacks and seeds")
        } footer: {
            FootnoteText("None of these has a runtime equivalent on the other screens: a callback registered here hears about the download the SDK does during init, and user properties given here are attached before anything else is recorded.")
        }
    }

    private var behaviourSection: some View {
        Section {
            LabeledField("sdkBehaviorSettings", text: $model.sdkBehaviorSettings, placeholder: "{}")
        } header: {
            Text("SDK behaviour settings")
        } footer: {
            FootnoteText("A JSON object the SDK treats as though the server had sent it. Pin it with disableSDKBehaviorSettingsUpdates above so a later server response cannot override it, which is what a reproducible test run needs.")
        }
    }

    // MARK: - Lifecycle

    private var lifecycleSection: some View {
        Section {
            Button("Initialize SDK") { model.initialize() }

            Button("Begin Session") { run("beginSession") { $0.sessions.beginSession() } }
            Button("Update Session") { run("updateSession") { $0.sessions.updateSession() } }
            Button("End Session") { run("endSession") { $0.sessions.endSession() } }

            Button("Suspend") { run("suspend") { $0.suspend() } }
            Button("Resume") { run("resume") { $0.resume() } }

            Button("Grant All Consent") { run("giveAllConsents") { $0.consent.giveAllConsents() } }
            Button("Revoke All Consent") { run("cancelAllConsents") { $0.consent.cancelAllConsents() } }

            Button("Halt", role: .destructive) { run("halt") { $0.halt() } }
            Button("Halt and Clear Storage", role: .destructive) { run("halt(clearStorage: true)") { $0.halt(clearStorage: true) } }
        } header: {
            Text("Lifecycle")
        } footer: {
            FootnoteText("Halting releases the instance but leaves what it wrote on disk, so initializing again picks the same device ID and queue back up. Clearing storage erases every key it owns, which is what a data deletion request needs. Either way the configuration above can then be changed and applied by initializing again.")
        }
    }

    /// Runs a lifecycle call against the configured instance, refusing rather than
    /// letting the SDK log a call it cannot service.
    private func run(_ label: String, _ body: (CountlyInstance) -> Void) {
        let instance = model.instance
        guard instance.isStarted else {
            AppLog.shared.log("\(label) ignored, the SDK is not started yet")
            return
        }
        AppLog.shared.log(label)
        body(instance)
        model.refreshStatus()
    }
}

/// A numeric configuration field whose prompt is the SDK's own default.
///
/// The default is shown rather than pre-filled so an untouched field means "leave
/// the SDK alone", which is not something a pre-filled value can express.
private struct TuningField: View {
    let label: String
    @Binding var text: String
    let defaultValue: String

    init(_ label: String, text: Binding<String>, default defaultValue: String) {
        self.label = label
        self._text = text
        self.defaultValue = defaultValue
    }

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
                .frame(width: 260, alignment: .leading)
            TextField(label, text: $text, prompt: Text(defaultValue))
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
        }
    }
}
