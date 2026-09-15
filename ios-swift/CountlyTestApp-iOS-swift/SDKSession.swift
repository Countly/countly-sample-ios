// SDKSession.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import Foundation
import Combine

// The SDK sources are compiled into this target from the `countly-sdk-swift`
// submodule, so there is nothing to import.

/// Owns the SDK lifecycle for the sample: the SDK starts only when the tester submits the Setup
/// screen, and can be halted and started again with different values without relaunching.
final class SDKSession: ObservableObject {
    static let shared = SDKSession()

    @Published private(set) var isInitialized = false
    @Published private(set) var activeHost: String?
    @Published private(set) var activeAppKey: String?

    /// Starts the SDK with `values`. Returns a message describing why the values are unusable, or nil on success.
    @discardableResult
    func initialize(with values: SetupValues) -> String? {
        if let error = values.validationError { return error }

        // See CountlyConfig.swift for the full list of options; only what the Setup screen exposes is set here.
        let config = CountlyConfig()
        config.host = values.normalizedHost
        config.appKey = values.normalizedAppKey
        config.enableDebug = values.debugLogging

        var features: [CountlyFeature] = []
        if values.crashReporting { features.append(.crashReporting) }
        if values.pushNotifications { features.append(.pushNotifications) }
        config.features = features

        if values.pushNotifications {
            // A sample build is signed with a development entitlement, so its token
            // belongs to the APNs sandbox and the server has to be told which one to
            // push through. Reporting the token whatever the permission state means
            // the device shows up before the alert is answered.
            config.pushTestMode = .development
            config.sendPushTokenAlways = true
        }

        let deviceID = values.normalizedDeviceID
        if !deviceID.isEmpty { config.deviceID = deviceID }

        // Surface content lifecycle in the in-app log so a tester sees what happened on device.
        config.content.globalContentCallback = { status, data in
            AppLog.shared.log("Content \(status == .completed ? "completed" : "closed"): \(data)")
        }

        Countly.shared.start(with: config)

        activeHost = config.host
        activeAppKey = config.appKey
        isInitialized = true
        AppLog.shared.log("SDK initialized: \(config.host) / \(config.appKey)")
        return nil
    }

    /// Halts the SDK so `initialize(with:)` can be called again with new values.
    func reset(clearStorage: Bool) {
        // halt(true) removes the app's whole UserDefaults domain; keep what the tester typed on the Setup screen.
        let store = SetupStore()
        let setup = store.load()
        Countly.shared.halt(clearStorage: clearStorage)
        if clearStorage { store.save(setup) }
        activeHost = nil
        activeAppKey = nil
        isInitialized = false
        AppLog.shared.log(clearStorage ? "SDK halted, storage cleared" : "SDK halted")
    }

    /// Points the running SDK at another server. Requests already queued keep the host they were created for.
    func setNewHost(_ host: String) {
        let value = SetupValues.normalizedHost(host)
        Countly.shared.setNewHost(value)
        activeHost = value
        AppLog.shared.log("setNewHost: \(value)")
    }

    /// Switches the running SDK to another app key. Requests already queued keep their app key.
    func setNewAppKey(_ appKey: String) {
        let value = appKey.trimmingCharacters(in: .whitespacesAndNewlines)
        Countly.shared.setNewAppKey(value)
        activeAppKey = value
        AppLog.shared.log("setNewAppKey: \(value)")
    }

    func currentDeviceID() -> String? {
        Countly.shared.deviceID.current
    }
}
