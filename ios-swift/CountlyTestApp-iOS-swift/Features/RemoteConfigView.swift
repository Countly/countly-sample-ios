// RemoteConfigView.swift
import SwiftUI
import Countly

struct RemoteConfigView: View {
    private var rc: CountlyRemoteConfig { Countly.sharedInstance().remoteConfig() }
    private let cb: RCDownloadCallback = { response, error, _, values in
        AppLog.shared.log(response == .responseSuccess ? "RC callback: \(values ?? [:])" : "RC callback error: \(error?.localizedDescription ?? "")")
    }
    var body: some View {
        Form {
            Section("Download") {
                ActionButton("Download All RC Values") { rc.downloadKeys(cb) }
                ActionButton("Download Specific RC Values") { rc.downloadSpecificKeys(["RC_KEY"], completionHandler: cb) }
                ActionButton("Download Omitting Specific RC Values") { rc.downloadOmittingKeys(["RC_KEY"], completionHandler: cb) }
            }
            Section("Get / Clear") {
                ActionButton("Get All RC Values") { AppLog.shared.log("\(rc.getAllValues())") }
                ActionButton("Get Specific RC Value") { AppLog.shared.log("\(rc.getValue("RC_KEY"))") }
                ActionButton("Clear All RC Values") { rc.clearAll() }
                ActionButton("Register RC Download Callback") { rc.registerDownloadCallback(cb) }
                ActionButton("Remove RC Download Callback") { rc.removeDownloadCallback(cb) }
            }
            Section("Enroll / A-B tests") {
                ActionButton("Get All RC Values And Enroll") { AppLog.shared.log("\(rc.getAllValuesAndEnroll())") }
                ActionButton("Get Specific RC Value And Enroll") { AppLog.shared.log("\(rc.getValueAndEnroll("RC_KEY"))") }
                ActionButton("Enroll Into AB Tests") { rc.enrollIntoABTests(forKeys: ["RC_KEY"]) }
                ActionButton("Exit AB Tests") { rc.exitABTests(forKeys: ["RC_KEY"]) }
            }
            Section("Testing / variants / experiments") {
                ActionButton("Fetch All Test Variants") { AppLog.shared.log("\(rc.testingGetAllVariants())") }
                ActionButton("Fetch Specific Test Variants") { AppLog.shared.log("\(rc.testingGetVariants(forKey: "RC_KEY"))") }
                ActionButton("Enroll Into Variant") {
                    rc.testingEnroll(intoVariant: "RC_KEY", variantName: "Variant A") { response, error in
                        AppLog.shared.log(response == .responseSuccess ? "Enrolled into variant" : "Enroll error: \(error?.localizedDescription ?? "")")
                    }
                }
                ActionButton("Download Experiment Information") {
                    rc.testingDownloadExperimentInformation { response, error in
                        if response == .responseSuccess { AppLog.shared.log("Experiments: \(rc.testingGetAllExperimentInfo())") }
                        else { AppLog.shared.log("Experiment info error: \(error?.localizedDescription ?? "")") }
                    }
                }
            }
        }
    }
}
