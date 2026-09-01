// RemoteConfigView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct RemoteConfigView: View {
    private var remoteConfig: RemoteConfigAPI { Countly.shared.remoteConfig }

    @State private var key = "welcome_text"
    @State private var token: RCCallbackToken?

    var body: some View {
        FeatureList {
            Section {
                LabeledField("Key", text: $key, placeholder: "welcome_text")
            } header: {
                Text("The key these buttons act on")
            }

            Section("Download") {
                ActionButton("Download All Values") {
                    remoteConfig.downloadKeys { result, error, fullUpdate, values in
                        AppLog.shared.log("download all: \(result), full: \(fullUpdate), count: \(values.count)\(error.map { ", error: \($0.localizedDescription)" } ?? "")")
                    }
                }
                ActionButton("Download Specific Keys") {
                    remoteConfig.downloadSpecificKeys([key]) { result, _, _, values in
                        AppLog.shared.log("download specific: \(result), count: \(values.count)")
                    }
                }
                ActionButton("Download Omitting Keys") {
                    remoteConfig.downloadOmittingKeys([key]) { result, _, _, values in
                        AppLog.shared.log("download omitting: \(result), count: \(values.count)")
                    }
                }
            }

            Section("Read") {
                ActionButton("Get One Value") {
                    let data = remoteConfig.getValue(key)
                    AppLog.shared.log("\(key): \(String(describing: data.value)), belongs to current user: \(data.isCurrentUsersData)")
                }
                ActionButton("Get All Values") {
                    let values = remoteConfig.getAllValues()
                    AppLog.shared.log("\(values.count) values: \(values.keys.sorted().joined(separator: ", "))")
                }
            }

            Section {
                ActionButton("Register a Download Callback") {
                    token = remoteConfig.registerDownloadCallback { result, _, _, values in
                        AppLog.shared.log("global callback: \(result), \(values.count) values")
                    }
                    AppLog.shared.log("callback token: \(token.map { "\($0)" } ?? "none, the SDK is not started")")
                }
                ActionButton("Remove that Callback") {
                    guard let token else { return AppLog.shared.log("no callback registered here yet") }
                    remoteConfig.removeDownloadCallback(token)
                    self.token = nil
                }
                ActionButton("Remove All Download Callbacks") {
                    remoteConfig.removeAllDownloadCallbacks()
                    token = nil
                }
                ActionButton("Clear All Values") { remoteConfig.clearAll() }
            } header: {
                Text("Callbacks and cache")
            } footer: {
                FootnoteText("A callback registered here fires on every download, including the automatic one at init when automatic triggers are switched on in Setup.")
            }
        }
    }
}
