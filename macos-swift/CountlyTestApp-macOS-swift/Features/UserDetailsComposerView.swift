// UserDetailsComposerView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// Edits the predefined user fields and any custom properties by hand.
struct UserDetailsComposerView: View {

    @State private var name = "John Doe"
    @State private var username = "johndoe"
    @State private var email = "john@example.com"
    @State private var organization = "Countly"
    @State private var phone = "+1234567890"
    @State private var gender = "M"
    @State private var birthYear = "1985"
    @State private var picture = ""

    @State private var custom: [KeyValue] = [KeyValue(key: "tier", value: "gold")]

    private var user: UserProfileAPI { Countly.shared.userProfile }

    var body: some View {
        FeatureList {
            Section {
                LabeledField("Name", text: $name)
                LabeledField("Username", text: $username)
                LabeledField("Email", text: $email)
                LabeledField("Organization", text: $organization)
                LabeledField("Phone", text: $phone)
                LabeledField("Gender", text: $gender)
                LabeledField("Birth year", text: $birthYear)
                LabeledField("Picture URL", text: $picture, placeholder: "optional")
            } header: {
                Text("Predefined")
            } footer: {
                FootnoteText("An empty field is sent as an empty string, which is how the server is told to clear it. Leave a field as it is to send it unchanged.")
            }

            KeyValueEditor(title: "Custom properties", pairs: $custom)

            Section {
                Button("Stage and Save") { save() }
                Button("Stage without Saving") { stage(); AppLog.shared.log("staged, nothing sent yet") }
                Button("Clear Staged Changes", role: .destructive) {
                    user.clear()
                    AppLog.shared.log("cleared everything staged")
                }
            } footer: {
                FootnoteText("Nothing leaves the device until save. Saving also flushes pending events first, so the profile always reaches the server before the events that follow it.")
            }
        }
    }

    private func stage() {
        var properties: [String: Any] = [
            "name": name, "username": username, "email": email,
            "organization": organization, "phone": phone, "gender": gender,
        ]
        if let year = Int(birthYear) { properties["byear"] = year }
        if !picture.isEmpty { properties["picture"] = picture }

        for pair in custom where !pair.key.isEmpty {
            properties[pair.key] = pair.typedValue
        }
        user.setProperties(properties)
    }

    private func save() {
        stage()
        user.save()
        AppLog.shared.log("saved profile with \(custom.filter { !$0.key.isEmpty }.count) custom propert(ies)")
    }
}
