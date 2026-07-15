// UserProfileView.swift
import SwiftUI
import Countly

struct UserProfileView: View {
    private var u: CountlyUserDetails { Countly.sharedInstance().userProfile() }
    var body: some View {
        Form {
            Section("Set properties (current)") {
                ActionButton("setProperty predefined (name)") { u.setProperty("name", value: "John Doe"); u.save() }
                ActionButton("setProperties (batch predefined + custom)") {
                    u.setProperties(["email": "john@doe.com", "organization": "UN", "byear": "1970", "custom1": "v1"]); u.save()
                }
                ActionButton("Clear a property (setProperty name = \"\")") { u.setProperty("name", value: ""); u.save() }
                ActionButton("setOnce") { u.setOnce("firstSeen", value: "2026"); u.save() }
            }
            Section("Numeric / array modifiers (current)") {
                ActionButton("increment") { u.increment("counter"); u.save() }
                ActionButton("incrementBy 5") { u.increment(by: "counter", value: 5); u.save() }
                ActionButton("multiply x2") { u.multiply("counter", value: 2); u.save() }
                ActionButton("max 100") { u.max("counter", value: 100); u.save() }
                ActionButton("min 0") { u.min("counter", value: 0); u.save() }
                ActionButton("push value") { u.push("tags", value: "a"); u.save() }
                ActionButton("push values") { u.push("tags", values: ["b", "c"]); u.save() }
                ActionButton("pushUnique value") { u.pushUnique("tags", value: "a"); u.save() }
                ActionButton("pull value") { u.pull("tags", value: "b"); u.save() }
            }
            Section("State (current)") {
                ActionButton("hasUnsyncedChanges?") { AppLog.shared.log("hasUnsyncedChanges = \(u.hasUnsyncedChanges())") }
                ActionButton("clear (discard queued)") { u.clear() }
                ActionButton("save") { u.save() }
            }
            Section {
                ActionButton("Record User Details (deprecated properties)") {
                    Countly.user().name = "John Doe" as CountlyUserDetailsNullableString
                    Countly.user().email = "john@doe.com" as CountlyUserDetailsNullableString
                    Countly.user().birthYear = 1970 as CountlyUserDetailsNullableNumber
                    Countly.user().organization = "United Nations" as CountlyUserDetailsNullableString
                    Countly.user().custom = ["k1": "v1"] as CountlyUserDetailsNullableDictionary
                    Countly.user().save()
                }
                ActionButton("set:value: (deprecated)") { Countly.user().set("key101", value: "value101"); Countly.user().save() }
                ActionButton("unSet: (deprecated)") { Countly.user().unSet("key101"); Countly.user().save() }
            } header: { Text("Legacy (deprecated)") }
              footer: { Text("Prefer userProfile.setProperty:value: / setProperties:.") }
        }
    }
}
