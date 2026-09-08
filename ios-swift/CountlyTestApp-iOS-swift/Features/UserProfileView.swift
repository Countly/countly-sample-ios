// UserProfileView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct UserProfileView: View {
    private var user: UserProfileAPI { Countly.shared.userProfile }

    var body: some View {
        Form {
            Section {
                ActionButton("Set Predefined Properties") {
                    user.setProperties([
                        "name": "John Doe",
                        "username": "johndoe",
                        "email": "john@example.com",
                        "organization": "Countly",
                        "phone": "+1234567890",
                        "gender": "M",
                        "byear": 1985,
                        "picture": "https://count.ly/logo.png",
                    ])
                }
                ActionButton("Set One Predefined Property") { user.setProperty("name", value: "Jane Doe") }
                ActionButton("Clear a Predefined Property") { user.setProperty("name", value: "") }
            } header: {
                Text("Predefined")
            } footer: {
                Text("The server clears a predefined field when it receives an empty string, and ignores null.")
            }

            Section("Custom properties") {
                ActionButton("Set Custom Properties") { user.setProperties(["tier": "gold", "visits": 3, "beta": true]) }
                ActionButton("Set One Custom Property") { user.setCustomProperty("tier", value: "platinum") }
                ActionButton("Unset a Custom Property") { user.unsetCustomProperty("tier") }
            }

            Section("Modifiers") {
                ActionButton("Set Once") { user.setOnce("first_seen", value: "2026-01-01") }
                ActionButton("Increment") { user.increment("visits") }
                ActionButton("Increment By") { user.incrementBy("score", value: 25) }
                ActionButton("Multiply") { user.multiply("score", value: 2) }
                ActionButton("Max") { user.max("highscore", value: 99) }
                ActionButton("Min") { user.min("lowscore", value: 1) }
                ActionButton("Push") { user.push("tags", value: "alpha") }
                ActionButton("Push Unique") { user.pushUnique("tags", value: "beta") }
                ActionButton("Pull") { user.pull("tags", value: "alpha") }
            }

            Section {
                ActionButton("Save") { user.save() }
                ActionButton("Clear All Staged Changes") { user.clear() }
            } header: {
                Text("Sending")
            } footer: {
                Text("Nothing leaves the device until save is called, and saving also flushes any pending events first, so a profile change always reaches the server before the events that follow it.")
            }
        }
    }
}
