// SetupView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// First screen of the app: collects server, app key and options, then starts the SDK on demand.
struct SetupView: View {
    @ObservedObject private var session = SDKSession.shared
    @AppStorage(SetupStore.Key.host) private var host = ""
    @AppStorage(SetupStore.Key.appKey) private var appKey = ""
    @AppStorage(SetupStore.Key.deviceID) private var deviceID = ""
    @AppStorage(SetupStore.Key.debugLogging) private var debugLogging = true
    @AppStorage(SetupStore.Key.crashReporting) private var crashReporting = true
    @AppStorage(SetupStore.Key.pushNotifications) private var pushNotifications = false
    @AppStorage(SetupStore.Key.autoInit) private var autoInit = false

    private var values: SetupValues {
        SetupValues(host: host, appKey: appKey, deviceID: deviceID, debugLogging: debugLogging,
                    crashReporting: crashReporting, pushNotifications: pushNotifications, autoInit: autoInit)
    }

    var body: some View {
        Form {
            Section {
                TextField("https://your.server.ly", text: $host)
                    .keyboardType(.URL)
                    .textContentType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("App key", text: $appKey)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } header: { Text("Server") }
              footer: { Text("Values stay on this device and are pre-filled on the next launch.") }

            Section {
                TextField("Leave empty for an SDK generated ID", text: $deviceID)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } header: { Text("Device ID (optional)") }
              footer: { Text("Set a known ID when a content zone or a test user on the server targets a specific device.") }

            Section {
                Toggle("Debug logging", isOn: $debugLogging)
                Toggle("Crash reporting", isOn: $crashReporting)
                Toggle("Push notifications feature", isOn: $pushNotifications)
                Toggle("Initialize automatically on launch", isOn: $autoInit)
            } header: { Text("Options") }
              footer: { Text("Push needs the push capability in the build and an APNs credential on the server. Content does not depend on it.") }

            Section {
                Button {
                    AppLog.shared.log("Initialize SDK")
                    session.initialize(with: values)
                } label: {
                    Text("Initialize SDK").frame(maxWidth: .infinity)
                }
                .disabled(values.validationError != nil)
            } footer: {
                Text(values.validationError ?? "Ready to initialize.")
                    .foregroundStyle(values.validationError == nil ? Color.secondary : Color.red)
            }
        }
    }
}
