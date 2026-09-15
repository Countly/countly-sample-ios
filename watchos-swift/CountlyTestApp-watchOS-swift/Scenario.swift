// Scenario.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import Foundation
import Countly

/// Launch argument driven runs, so a watch simulator can be exercised from the
/// command line the way the phone sample is: `-CountlyScenario basic` records a
/// fixed set of data against `-CountlyHost` (default `http://localhost:8080`).
enum Scenario {

    static var name: String? {
        UserDefaults.standard.string(forKey: "CountlyScenario")
    }

    static func configure(_ config: CountlyConfig) {
        guard name != nil else { return }
        config.appKey = UserDefaults.standard.string(forKey: "CountlyAppKey") ?? "parity_app_key"
        config.host = UserDefaults.standard.string(forKey: "CountlyHost") ?? "http://localhost:8080"
        config.deviceID = UserDefaults.standard.string(forKey: "CountlyDeviceID") ?? "parity-watch"
        config.enableDebug = true
        config.internalLogLevel = .debug
        config.features = [.crashReporting]
        config.updateSessionPeriod = 5
        config.enableRemoteConfigAutomaticTriggers = false
    }

    static func runIfRequested() {
        guard let scenario = name else { return }
        let cly = Countly.shared
        let steps: [() -> Void]

        switch scenario {
        case "basic":
            steps = [
                { cly.events.recordEvent("watch_event", segmentation: ["source": "watch", "n": 1]) },
                { _ = cly.views.startView("WatchView") },
                { cly.userProfile.setProperties(["name": "Watch Tester", "username": "watch", "byear": 1990]); cly.userProfile.save() },
                { cly.crashes.addCrashBreadcrumb("watch breadcrumb") },
                { cly.crashes.recordError("WatchHandledError", isFatal: false, stackTrace: ["frame one"], segmentation: ["source": "watch"]) },
                { cly.remoteConfig.downloadKeys { response, _, _, values in NSLog("[SCENARIO] remote config: \(response), keys: \(values.keys.sorted())") } },
                { cly.views.stopAllViews() },
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]
        case "session-auto":
            // Nothing but the automatic session, the update timer and the end.
            steps = Array(repeating: { NSLog("[SCENARIO] waiting") }, count: 14) + [
                { cly.requestQueue.attemptToSendStoredRequests() },
            ]
        default:
            NSLog("[SCENARIO] unknown scenario [\(scenario)]")
            return
        }

        NSLog("[SCENARIO] starting [\(scenario)], stepCount: \(steps.count)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { step(steps, 0) }
    }

    private static func step(_ steps: [() -> Void], _ index: Int) {
        guard index < steps.count else {
            NSLog("[SCENARIO] done, stepCount: \(steps.count)")
            return
        }
        NSLog("[SCENARIO] step \(index + 1)/\(steps.count)")
        steps[index]()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { step(steps, index + 1) }
    }
}
