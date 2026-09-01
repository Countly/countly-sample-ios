// ABTestingView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct ABTestingView: View {
    private var remoteConfig: RemoteConfigAPI { Countly.shared.remoteConfig }

    @State private var key = "welcome_text"
    @State private var variant = "A"

    var body: some View {
        FeatureList {
            Section {
                LabeledField("Key", text: $key, placeholder: "welcome_text")
                LabeledField("Variant", text: $variant, placeholder: "A")
            } header: {
                Text("The key and variant these buttons act on")
            }

            Section {
                ActionButton("Get Value and Enroll") {
                    AppLog.shared.log("value: \(String(describing: remoteConfig.getValueAndEnroll(key).value))")
                }
                ActionButton("Get All Values and Enroll") {
                    AppLog.shared.log("\(remoteConfig.getAllValuesAndEnroll().count) values, enrolled in all")
                }
            } header: {
                Text("Enroll by reading")
            } footer: {
                FootnoteText("Reading a value this way is what puts the device into the experiment behind that key.")
            }

            Section("Enroll explicitly") {
                ActionButton("Enroll into A/B Tests") { remoteConfig.enrollIntoABTests(forKeys: [key]) }
                ActionButton("Exit A/B Tests") { remoteConfig.exitABTests(forKeys: [key]) }
            }

            Section {
                ActionButton("Download Variant Information") {
                    remoteConfig.testingDownloadVariantInformation { result, error in
                        AppLog.shared.log("variants: \(result)\(error.map { ", \($0.localizedDescription)" } ?? "")")
                    }
                }
                ActionButton("Print All Variants") { AppLog.shared.log("\(remoteConfig.testingGetAllVariants())") }
                ActionButton("Print Variants for the Key") { AppLog.shared.log("\(remoteConfig.testingGetVariants(forKey: key))") }
                ActionButton("Download Experiment Information") {
                    remoteConfig.testingDownloadExperimentInformation { result, error in
                        AppLog.shared.log("experiments: \(result)\(error.map { ", \($0.localizedDescription)" } ?? "")")
                    }
                }
                ActionButton("Print All Experiments") {
                    let all = remoteConfig.testingGetAllExperimentInfo()
                    AppLog.shared.log(all.isEmpty ? "no experiments" : all.map { "\($0.value.experimentName) -> \($0.value.currentVariant)" }.joined(separator: "; "))
                }
                ActionButton("Enroll into the Named Variant") {
                    remoteConfig.testingEnrollIntoVariant(key: key, variantName: variant) { result, error in
                        AppLog.shared.log("enroll into variant: \(result)\(error.map { ", \($0.localizedDescription)" } ?? "")")
                    }
                }
            } header: {
                Text("Testing helpers")
            } footer: {
                FootnoteText("These exist so a tester can force this device into a chosen variant. They are not meant for production code.")
            }
        }
    }
}
