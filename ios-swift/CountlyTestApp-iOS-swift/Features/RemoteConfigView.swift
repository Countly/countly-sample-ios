// RemoteConfigView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct RemoteConfigView: View {
    private var remoteConfig: RemoteConfigAPI { Countly.shared.remoteConfig }

    var body: some View {
        Form {
            Section("Download") {
                ActionButton("Download All Values") {
                    remoteConfig.downloadKeys { result, error, fullUpdate, values in
                        AppLog.shared.log("download all: \(result), full: \(fullUpdate), count: \(values.count)\(error.map { ", error: \($0.localizedDescription)" } ?? "")")
                    }
                }
                ActionButton("Download Specific Keys") {
                    remoteConfig.downloadSpecificKeys(["welcome_text"]) { result, _, _, values in
                        AppLog.shared.log("download specific: \(result), count: \(values.count)")
                    }
                }
                ActionButton("Download Omitting Keys") {
                    remoteConfig.downloadOmittingKeys(["welcome_text"]) { result, _, _, values in
                        AppLog.shared.log("download omitting: \(result), count: \(values.count)")
                    }
                }
            }

            Section("Read") {
                ActionButton("Get One Value") {
                    let data = remoteConfig.getValue("welcome_text")
                    AppLog.shared.log("welcome_text: \(String(describing: data.value)), belongs to current user: \(data.isCurrentUsersData)")
                }
                ActionButton("Get All Values") {
                    let values = remoteConfig.getAllValues()
                    AppLog.shared.log("\(values.count) values: \(values.keys.sorted().joined(separator: ", "))")
                }
            }

            Section {
                ActionButton("Register a Download Callback") {
                    remoteConfig.registerDownloadCallback { result, _, _, values in
                        AppLog.shared.log("global callback: \(result), \(values.count) values")
                    }
                }
                ActionButton("Remove All Download Callbacks") { remoteConfig.removeAllDownloadCallbacks() }
                ActionButton("Clear All Values") { remoteConfig.clearAll() }
            } header: {
                Text("Callbacks and cache")
            } footer: {
                Text("A callback registered here fires on every download, including the automatic one at init.")
            }
        }
    }
}
