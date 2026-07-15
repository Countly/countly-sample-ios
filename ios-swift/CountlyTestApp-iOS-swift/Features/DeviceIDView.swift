// DeviceIDView.swift
import SwiftUI
import Countly

struct DeviceIDView: View {
    private var cly: Countly { Countly.sharedInstance() }
    var body: some View {
        Form {
            Section("Inspect") {
                ActionButton("Show deviceID") { AppLog.shared.log("deviceID = \(cly.deviceID())") }
                ActionButton("Show deviceIDType") { AppLog.shared.log("deviceIDType = \(String(describing: cly.deviceIDType()))") }
            }
            Section("Change (current)") {
                ActionButton("Change Device ID (with merge)") { cly.changeDeviceID(withMerge: "user@example.com") }
                ActionButton("Change Device ID (without merge)") { cly.changeDeviceIDWithoutMerge("user@example.com") }
                ActionButton("Enable Temporary Device ID Mode") { cly.enableTemporaryDeviceIDMode() }
                ActionButton("Set ID") { cly.setID("custom-id") }
            }
            Section {
                ActionButton("Set New Device ID, no server merge (deprecated)") { cly.setNewDeviceID("user@example.com", onServer: false) }
                ActionButton("Set New Device ID, server merge (deprecated)") { cly.setNewDeviceID("user@example.com", onServer: true) }
            } header: { Text("Legacy (deprecated)") }
              footer: { Text("Prefer changeDeviceIDWithMerge:/changeDeviceIDWithoutMerge:.") }
        }
    }
}
