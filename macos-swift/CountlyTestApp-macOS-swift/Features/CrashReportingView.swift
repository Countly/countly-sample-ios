// CrashReportingView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct CrashReportingView: View {
    private var crashes: CrashesAPI { Countly.shared.crashes }

    var body: some View {
        FeatureList {
            Section("Handled") {
                ActionButton("Record Handled Error") {
                    crashes.recordError("HandledError", isFatal: false,
                                        stackTrace: Thread.callStackSymbols,
                                        segmentation: ["where": "sample app"])
                }
                ActionButton("Record Handled Exception") {
                    crashes.recordException(NSException(name: .init("MyException"), reason: "MyReason", userInfo: ["info": "value"]),
                                            isFatal: false, stackTrace: nil, segmentation: nil)
                }
                ActionButton("Record a Swift Error") {
                    crashes.recordError(CocoaError(.fileNoSuchFile), isFatal: false, stackTrace: nil, segmentation: nil)
                }
                ActionButton("Record Fatal Error (reported, not crashing)") {
                    crashes.recordError("FatalError", isFatal: true, stackTrace: nil, segmentation: nil)
                }
            }

            Section {
                ActionButton("Add Crash Breadcrumb") { crashes.addCrashBreadcrumb("breadcrumb at \(Date())") }
                ActionButton("Clear Crash Breadcrumbs") { crashes.clearCrashBreadcrumbs() }
                ActionButton("Set Crash Segmentation") { crashes.setCrashSegmentation(["SomeOtherSDK": "v3.4.5"]) }
            } header: {
                Text("Context")
            } footer: {
                FootnoteText("Breadcrumbs are kept across launches, so the ones left before a crash are attached to the report sent on the next start.")
            }

            Section {
                ActionButton("Unrecognized Selector") { NSObject().perform(NSSelectorFromString("nonExistentSelector")) }
                ActionButton("Array Out of Bounds") { let a = [0, 1, 2]; AppLog.shared.log("\(a[5])") }
                ActionButton("Force Unwrap nil") { let o: String? = nil; AppLog.shared.log(o!) }
                ActionButton("Assertion Failure") { assertionFailure("deliberate assertion failure") }
                ActionButton("Signal (SIGABRT)") { abort() }
            } header: {
                Text("Fatal — these kill the app")
            } footer: {
                FootnoteText("The uncaught exception and signal handlers are installed on macOS too. The report is written to the request queue as the process dies and sent on the next launch, so relaunch the app to see it arrive.")
            }
        }
    }
}
