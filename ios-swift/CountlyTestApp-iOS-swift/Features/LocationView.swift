// LocationView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI
import CoreLocation

struct LocationView: View {
    private var location: LocationAPI { Countly.shared.location }

    var body: some View {
        Form {
            Section {
                ActionButton("Record Everything") {
                    location.recordLocation(CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917),
                                            city: "Tokyo", isoCountryCode: "JP", ipAddress: "128.0.0.1")
                }
                ActionButton("Record City and Country") { location.recordLocation(city: "Istanbul", isoCountryCode: "TR") }
                ActionButton("Record Coordinates Only") { location.recordLocation(CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784)) }
                ActionButton("Record IP Address Only") { location.recordLocation(ipAddress: "10.0.0.1") }
            } header: {
                Text("Record")
            } footer: {
                Text("The SDK never asks the device for a location. Everything here is supplied by the host application.")
            }

            Section {
                ActionButton("Disable Location") { location.disableLocationInfo() }
            } header: {
                Text("Disable")
            } footer: {
                Text("Sends an empty location, which clears what the server holds and stops it deriving one from the IP address.")
            }
        }
    }
}
