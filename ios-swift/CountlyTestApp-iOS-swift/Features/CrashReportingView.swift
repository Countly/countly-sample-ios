// CrashReportingView.swift
import SwiftUI
import Countly

struct CrashReportingView: View {
    private var cly: Countly { Countly.sharedInstance() }
    private var sampleException: NSException {
        NSException(name: .init("MyException"), reason: "MyReason", userInfo: ["key": "value"])
    }
    var body: some View {
        Form {
            Section("Record exception / error (current)") {
                ActionButton("Record Exception") { cly.record(sampleException) }
                ActionButton("Record Exception (fatal)") { cly.record(sampleException, isFatal: true) }
                ActionButton("Record Exception (stack + seg)") { cly.record(sampleException, isFatal: false, stackTrace: Thread.callStackSymbols, segmentation: ["k": "v"]) }
                ActionButton("Record Error (stack)") { cly.recordError("SampleError", stackTrace: Thread.callStackSymbols) }
                ActionButton("Record Error (fatal + stack + seg)") { cly.recordError("SampleError", isFatal: false, stackTrace: Thread.callStackSymbols, segmentation: ["k": "v"]) }
            }
            Section("Crash logs (current)") {
                ActionButton("Custom Crash Log") { cly.recordCrashLog("This is a custom crash log.") }
                ActionButton("Clear Crash Logs") { cly.clearCrashLogs() }
            }
            Section("Simulate crash (native)") {
                ActionButton("Out of Bounds") { let a = ["one"]; _ = a[5] }
                ActionButton("Unwrapping nil Optional") { let x: Int? = nil; _ = x! }
                ActionButton("Assert Fail") { assert(0 == 1, "test assert") }
                ActionButton("Terminate (SIGABRT)") { kill(getpid(), SIGABRT) }
                ActionButton("Terminate (SIGTERM)") { kill(getpid(), SIGTERM) }
            }
            Section {
                ActionButton("Record Handled Exception (deprecated)") { cly.recordHandledException(sampleException) }
                ActionButton("Record Handled Exception w/ Stack (deprecated)") { cly.recordHandledException(sampleException, withStackTrace: Thread.callStackSymbols) }
                ActionButton("Record Unhandled Exception w/ Stack (deprecated)") { cly.recordUnhandledException(sampleException, withStackTrace: Thread.callStackSymbols) }
            } header: { Text("Legacy (deprecated)") }
              footer: { Text("Prefer recordException:/recordException:isFatal:stackTrace:segmentation:.") }
        }
    }
}
