// SetupLogic.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import Foundation

/// Everything the tester types on the Setup screen. Persisted through `SetupStore`.
struct SetupValues: Equatable {
    var host: String
    var appKey: String
    var deviceID: String = ""
    var debugLogging: Bool = true
    var crashReporting: Bool = true
    var pushNotifications: Bool = false
    var autoInit: Bool = false

    /// Server URL without surrounding whitespace or trailing slashes.
    var normalizedHost: String { SetupValues.normalizedHost(host) }

    static func normalizedHost(_ raw: String) -> String {
        var value = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        while value.hasSuffix("/") { value.removeLast() }
        return value
    }

    var normalizedAppKey: String { appKey.trimmingCharacters(in: .whitespacesAndNewlines) }

    var normalizedDeviceID: String { deviceID.trimmingCharacters(in: .whitespacesAndNewlines) }

    /// Human readable reason the values cannot be used to start the SDK, or nil when they can.
    var validationError: String? {
        let hostValue = normalizedHost
        if hostValue.isEmpty { return "Server URL is required." }
        guard let url = URL(string: hostValue),
              let scheme = url.scheme?.lowercased(), ["http", "https"].contains(scheme),
              let hostName = url.host, !hostName.isEmpty else {
            return "Server URL must start with http:// or https:// and include a host name."
        }
        if normalizedAppKey.isEmpty { return "App key is required." }
        return nil
    }
}

/// Reads and writes `SetupValues` in UserDefaults. The SwiftUI Setup form binds to the same keys.
struct SetupStore {
    enum Key {
        static let host = "setup.host"
        static let appKey = "setup.appKey"
        static let deviceID = "setup.deviceID"
        static let debugLogging = "setup.debugLogging"
        static let crashReporting = "setup.crashReporting"
        static let pushNotifications = "setup.pushNotifications"
        static let autoInit = "setup.autoInit"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> SetupValues {
        SetupValues(host: defaults.string(forKey: Key.host) ?? "",
                    appKey: defaults.string(forKey: Key.appKey) ?? "",
                    deviceID: defaults.string(forKey: Key.deviceID) ?? "",
                    debugLogging: bool(Key.debugLogging, default: true),
                    crashReporting: bool(Key.crashReporting, default: true),
                    pushNotifications: bool(Key.pushNotifications, default: false),
                    autoInit: bool(Key.autoInit, default: false))
    }

    func save(_ values: SetupValues) {
        defaults.set(values.host, forKey: Key.host)
        defaults.set(values.appKey, forKey: Key.appKey)
        defaults.set(values.deviceID, forKey: Key.deviceID)
        defaults.set(values.debugLogging, forKey: Key.debugLogging)
        defaults.set(values.crashReporting, forKey: Key.crashReporting)
        defaults.set(values.pushNotifications, forKey: Key.pushNotifications)
        defaults.set(values.autoInit, forKey: Key.autoInit)
    }

    private func bool(_ key: String, default defaultValue: Bool) -> Bool {
        defaults.object(forKey: key) == nil ? defaultValue : defaults.bool(forKey: key)
    }
}
