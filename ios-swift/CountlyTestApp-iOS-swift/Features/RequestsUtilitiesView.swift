// RequestsUtilitiesView.swift
import SwiftUI
import Countly
import CoreLocation

struct RequestsUtilitiesView: View {
    private var cly: Countly { Countly.sharedInstance() }
    var body: some View {
        Form {
            Section("Override config") {
                ActionButton("Set New Host") { cly.setNewHost("https://your.server.ly") }
                ActionButton("Set New App Key") { cly.setNewAppKey("YOUR_APP_KEY") }
                ActionButton("Set New URLSessionConfiguration") { cly.setNewURLSessionConfiguration(.default) }
                ActionButton("Add Custom Network Request Headers") { cly.addCustomNetworkRequestHeaders(["X-Sample": "1"]) }
            }
            Section("Queue") {
                ActionButton("Flush Queues") { cly.flushQueues() }
                ActionButton("Attempt To Send Stored Requests") { cly.attemptToSendStoredRequests() }
                ActionButton("Add Direct Request") { cly.addDirectRequest(["dr_key": "dr_value"]) }
                ActionButton("Record Metrics") { cly.recordMetrics(["_app_version": "9.9"]) }
                ActionButton("Replace All App Keys In Queue") { cly.replaceAllAppKeysInQueueWithCurrentAppKey() }
                ActionButton("Remove Different App Keys From Queue") { cly.removeDifferentAppKeysFromQueue() }
            }
            Section("Location") {
                ActionButton("Record Location") { cly.recordLocation(CLLocationCoordinate2D(latitude: 35.6789, longitude: 43.1234), city: "Tokyo", isoCountryCode: "JP", ip: "255.255.255.255") }
                ActionButton("Disable Location Info") { cly.disableLocationInfo() }
            }
            Section("Lifecycle") {
                ActionButton("Halt") { cly.halt() }
                ActionButton("Halt (clear storage)") { cly.halt(true) }
            }
        }
    }
}
