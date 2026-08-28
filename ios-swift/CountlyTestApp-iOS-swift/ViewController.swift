// ViewController.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import UIKit
import CoreLocation

extension ViewController: UITableViewDataSource, UITableViewDelegate {}

enum TestSection: Int, CaseIterable {
    case customEvents = 0
    case views
    case sessions
    case userProfile
    case consent
    case deviceID
    case crashReporting
    case remoteConfig
    case abTesting
    case feedbackWidgets
    case content
    case performance
    case location
    case attribution
    case pushNotifications
    case requestQueue
    case multipleInstances
    case multiThreading
    case others
}

class ViewController: UIViewController {

    // Kept in step with `tests` below: one title per section, one array of row
    // titles per section, and one `case` per section in `didSelectRowAt`.
    let sections: [String] = [
        "Custom Events",
        "Views",
        "Sessions",
        "User Profile",
        "Consent",
        "Device ID",
        "Crash Reporting",
        "Remote Config",
        "A/B Testing",
        "Feedback Widgets",
        "Content",
        "Performance Monitoring",
        "Location",
        "Attribution",
        "Push Notifications",
        "Request Queue",
        "Multiple Instances",
        "Multi Threading",
        "Others",
    ]

    let tests: [[String]] = [
        // Custom Events
        ["Record Event",
         "Record Event with Count",
         "Record Event with Sum",
         "Record Event with Duration",
         "Record Event with Segmentation",
         "Record Event with Segmentation & Count",
         "Record Event with Segmentation, Count & Sum",
         "Record Event with Segmentation, Count, Sum & Duration",
         "Start Event",
         "End Event",
         "End Event with Segmentation, Count & Sum",
         "Cancel Event",
         "Record Event with Over-Long Key & Value",
         "Record Event with Empty Key (dropped)"],

        // Views
        ["Start View",
         "Start Auto Stopped View",
         "Stop View by Name",
         "Stop View by ID",
         "Pause Current View",
         "Resume Current View",
         "Stop All Views",
         "Add Segmentation to View by Name",
         "Add Segmentation to View by ID",
         "Set Global View Segmentation",
         "Update Global View Segmentation",
         "Add Auto View Tracking Exclusion",
         "Open Modal View Controller",
         "Push View Controller"],

        // Sessions
        ["Begin Session",
         "Update Session",
         "End Session",
         "Suspend SDK",
         "Resume SDK"],

        // User Profile
        ["Set Predefined Properties",
         "Set Custom Properties",
         "Set Custom Property",
         "Unset Custom Property",
         "Set Once",
         "Increment",
         "Increment By",
         "Multiply",
         "Max",
         "Min",
         "Push",
         "Push Unique",
         "Pull",
         "Clear Predefined Property (empty string)",
         "Save",
         "Clear All"],

        // Consent
        ["Give Consent for Sessions",
         "Give Consent for Events & Views",
         "Give All Consents",
         "Cancel Consent for Events",
         "Cancel All Consents",
         "Check Consent for Sessions"],

        // Device ID
        ["Print Current Device ID & Type",
         "Set ID (SDK decides merge)",
         "Change Device ID with Merge",
         "Change Device ID without Merge",
         "Enable Temporary ID Mode",
         "Leave Temporary ID Mode"],

        // Crash Reporting
        ["Record Handled Error",
         "Record Handled Exception",
         "Record Fatal Error",
         "Add Crash Breadcrumb",
         "Clear Crash Breadcrumbs",
         "Set Crash Segmentation",
         "Fatal: Unrecognized Selector",
         "Fatal: Array Out of Bounds",
         "Fatal: Force Unwrap nil",
         "Fatal: Assertion Failure",
         "Fatal: Signal (SIGABRT)"],

        // Remote Config
        ["Download All Values",
         "Download Specific Keys",
         "Download Omitting Keys",
         "Get Value",
         "Get All Values",
         "Register Download Callback",
         "Remove All Download Callbacks",
         "Clear All Values"],

        // A/B Testing
        ["Get Value and Enroll",
         "Get All Values and Enroll",
         "Enroll into A/B Tests",
         "Exit A/B Tests",
         "Download Variant Information",
         "Print All Variants",
         "Print Variants for Key",
         "Download Experiment Information",
         "Print All Experiments",
         "Enroll into Variant"],

        // Feedback Widgets
        ["Get Available Widgets",
         "Present NPS",
         "Present Survey",
         "Present Rating",
         "Record Rating Widget Manually"],

        // Content
        ["Enter Content Zone",
         "Enter Content Zone with Tags",
         "Refresh Content Zone",
         "Change Content Tags",
         "Preview Content by ID",
         "Exit Content Zone"],

        // Performance Monitoring
        ["Record Network Trace",
         "Start Custom Trace",
         "End Custom Trace",
         "End Custom Trace with Metrics",
         "Cancel Custom Trace",
         "Clear All Custom Traces",
         "App Loading Finished"],

        // Location
        ["Record Full Location",
         "Record City & Country Only",
         "Record Coordinates Only",
         "Record IP Only",
         "Disable Location"],

        // Attribution
        ["Record Direct Attribution",
         "Record Direct Attribution without Campaign User",
         "Record Indirect Attribution (IDFA)",
         "Record Indirect Attribution (multiple identifiers)"],

        // Push Notifications
        ["Ask for Notification Permission",
         "Ask for Notification Permission with Options",
         "Record Push Token",
         "Clear Push Token",
         "Record Push Action Manually"],

        // Request Queue
        ["Print Queue Size",
         "Attempt to Send Stored Requests",
         "Flush Queues",
         "Replace All App Keys with Current",
         "Remove Different App Keys",
         "Add Direct Request",
         "Record Metrics Override",
         "Add Queue Flush Runnable",
         "Clear Queue Flush Runnables"],

        // Multiple Instances
        ["Start Second Instance",
         "Record Event on Second Instance",
         "List Instances",
         "Get Second Instance if it Exists",
         "Halt Second Instance",
         "Halt Second Instance and Clear Storage",
         "Halt All Instances"],

        // Multi Threading
        ["Thread 1", "Thread 2", "Thread 3", "Thread 4",
         "Thread 5", "Thread 6", "Thread 7", "Thread 8"],

        // Others
        ["Set New Host",
         "Set New App Key",
         "Add Custom Network Request Headers",
         "Set New URL Session Configuration",
         "Halt SDK",
         "Halt SDK and Clear Storage"],
    ]

    /// Queues for the multi threading section, created lazily per row.
    var queues: [DispatchQueue?] = Array(repeating: nil, count: 8)

    /// Kept so the view rows can pause, resume and stop the same view.
    var currentViewID: String?

    /// A second SDK instance, for the multiple instances section.
    let secondInstanceName = "secondary"

    /// A remote config callback registered by one row and removed by another.
    var remoteConfigCallback: RCDownloadCallback?

    @IBOutlet weak var tableView: UITableView!

    let startSection = TestSection.customEvents.rawValue

    override func viewDidLoad() {
        super.viewDidLoad()

        // Guards against the three arrays drifting apart, which is otherwise a
        // crash on a row nobody happened to tap.
        assert(sections.count == tests.count, "every section needs a row list")
        assert(sections.count == TestSection.allCases.count, "every section needs a case")

        tableView.scrollToRow(at: IndexPath(row: 0, section: startSection),
                              at: .top,
                              animated: false)

        if ProcessInfo.processInfo.arguments.contains("-CountlySmokeTest") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.runSmokeTest() }
        }
    }

    /// Taps one row in every section, to prove the wiring end to end.
    private func runSmokeTest() {
        let plan: [(TestSection, [Int])] = [
            (.customEvents, [0, 4, 8, 9]),
            (.views, [0, 9, 2]),
            (.userProfile, [0, 5, 14]),
            (.consent, [2, 5]),
            (.deviceID, [0]),
            (.crashReporting, [3, 0, 1]),
            (.remoteConfig, [0, 3, 4]),
            (.abTesting, [2, 3]),
            (.feedbackWidgets, [0, 4]),
            (.performance, [0, 1, 3]),
            (.location, [0, 4]),
            (.requestQueue, [0, 5, 6, 1]),
            (.multipleInstances, [0, 1, 2]),
            (.multiThreading, [0]),
        ]

        var steps: [(TestSection, Int)] = []
        for (section, rows) in plan {
            for row in rows { steps.append((section, row)) }
        }

        func step(_ index: Int) {
            guard index < steps.count else {
                NSLog("[SMOKE] done, %d steps", steps.count)
                Countly.shared.requestQueue.attemptToSendStoredRequests()
                return
            }
            let (section, row) = steps[index]
            NSLog("[SMOKE] %@ / %@", self.sections[section.rawValue], self.tests[section.rawValue][row])
            self.tableView(self.tableView, didSelectRowAt: IndexPath(row: row, section: section.rawValue))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { step(index + 1) }
        }
        step(0)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Table view

    func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.backgroundView?.backgroundColor = .gray
        headerView.textLabel?.textColor = .white
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tests[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CountlyTestCell")
        cell.textLabel?.text = tests[indexPath.section][indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 12)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let name = tests[indexPath.section][indexPath.row]
        print("Test: \(sections[indexPath.section]) - \(name)")

        guard let section = TestSection(rawValue: indexPath.section) else { return }
        let row = indexPath.row

        switch section {
        case .customEvents:      runCustomEvents(row)
        case .views:             runViews(row)
        case .sessions:          runSessions(row)
        case .userProfile:       runUserProfile(row)
        case .consent:           runConsent(row)
        case .deviceID:          runDeviceID(row)
        case .crashReporting:    runCrashReporting(row)
        case .remoteConfig:      runRemoteConfig(row)
        case .abTesting:         runABTesting(row)
        case .feedbackWidgets:   runFeedbackWidgets(row)
        case .content:           runContent(row)
        case .performance:       runPerformance(row)
        case .location:          runLocation(row)
        case .attribution:       runAttribution(row)
        case .pushNotifications: runPush(row)
        case .requestQueue:      runRequestQueue(row)
        case .multipleInstances: runMultipleInstances(row)
        case .multiThreading:    runMultiThreading(row)
        case .others:            runOthers(row)
        }
    }

    // MARK: - Custom Events

    private func runCustomEvents(_ row: Int) {
        let events = Countly.shared.events

        switch row {
        case 0: events.recordEvent("button-click")
        case 1: events.recordEvent("button-click", count: 5)
        case 2: events.recordEvent("button-click", sum: 1.99)
        case 3: events.recordEvent("button-click", duration: 3.14)
        case 4: events.recordEvent("button-click", segmentation: ["k": "v"])
        case 5: events.recordEvent("button-click", segmentation: ["k": "v"], count: 5)
        case 6: events.recordEvent("button-click", segmentation: ["k": "v"], count: 5, sum: 1.99)
        case 7: events.recordEvent("button-click", segmentation: ["k": "v"], count: 5, sum: 1.99, duration: 0.314)
        case 8: events.startEvent("timed-event")
        case 9: events.endEvent("timed-event")
        case 10: events.endEvent("timed-event", segmentation: ["k": "v"], count: 1, sum: 0)
        case 11: events.cancelEvent("timed-event")
        case 12:
            // Truncated to the configured limits rather than rejected.
            events.recordEvent(String(repeating: "k", count: 200),
                               segmentation: [String(repeating: "s", count: 200): String(repeating: "v", count: 300)])
        case 13: events.recordEvent("")
        default: break
        }
    }

    // MARK: - Views

    private func runViews(_ row: Int) {
        let views = Countly.shared.views

        switch row {
        case 0: currentViewID = views.startView("View A", segmentation: ["origin": "manual"])
        case 1: currentViewID = views.startAutoStoppedView("Auto Stopped View")
        case 2: views.stopView(name: "View A", segmentation: ["reason": "navigated"])
        case 3:
            guard let id = currentViewID else { return print("no view has been started yet") }
            views.stopView(id: id)
        case 4:
            guard let id = currentViewID else { return print("no view has been started yet") }
            views.pauseView(id: id)
        case 5:
            guard let id = currentViewID else { return print("no view has been started yet") }
            views.resumeView(id: id)
        case 6: views.stopAllViews(segmentation: ["bulk": "yes"])
        case 7: views.addSegmentation(toViewWithName: "View A", segmentation: ["late": "addition"])
        case 8:
            guard let id = currentViewID else { return print("no view has been started yet") }
            views.addSegmentation(toViewWithID: id, segmentation: ["late": "addition"])
        case 9: views.setGlobalViewSegmentation(["tier": "gold"])
        case 10: views.updateGlobalViewSegmentation(["tier": "platinum", "extra": "added"])
        case 11: views.addAutoViewTrackingExclusionList(["TestViewControllerModal"])
        // Both are here for automatic view tracking: with
        // `enableAutomaticViewTracking` on, presenting these reports a view named
        // after the controller's title, or its class when it has none.
        case 12:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let modal = storyboard.instantiateViewController(withIdentifier: "TestViewControllerModal") as? TestViewControllerModal else { return }
            modal.title = "MyModalViewTitle"
            present(modal, animated: true)
        case 13:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let pushed = storyboard.instantiateViewController(withIdentifier: "TestViewControllerPushPop") as? TestViewControllerPushPop else { return }
            pushed.title = "MyPushedViewTitle"
            present(UINavigationController(rootViewController: pushed), animated: true)
        default: break
        }
    }

    // MARK: - Sessions

    private func runSessions(_ row: Int) {
        let sessions = Countly.shared.sessions

        switch row {
        // These three are ignored unless `manualSessionHandling` is set: with
        // automatic sessions on, the SDK owns the session and says so in the log.
        case 0: sessions.beginSession()
        case 1: sessions.updateSession()
        case 2: sessions.endSession()
        case 3: Countly.shared.suspend()
        case 4: Countly.shared.resume()
        default: break
        }
    }

    // MARK: - User Profile

    private func runUserProfile(_ row: Int) {
        let user = Countly.shared.userProfile

        switch row {
        case 0:
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
        case 1: user.setProperties(["tier": "gold", "visits": 3, "beta": true])
        case 2: user.setCustomProperty("tier", value: "platinum")
        case 3: user.unsetCustomProperty("tier")
        case 4: user.setOnce("first_seen", value: "2026-01-01")
        case 5: user.increment("visits")
        case 6: user.incrementBy("score", value: 25)
        case 7: user.multiply("score", value: 2)
        case 8: user.max("highscore", value: 99)
        case 9: user.min("lowscore", value: 1)
        case 10: user.push("tags", value: "alpha")
        case 11: user.pushUnique("tags", value: "beta")
        case 12: user.pull("tags", value: "alpha")
        // The server clears a predefined field on an empty string and ignores nil.
        case 13: user.setProperty("name", value: "")
        case 14: user.save()
        case 15: user.clear()
        default: break
        }
    }

    // MARK: - Consent

    private func runConsent(_ row: Int) {
        let consent = Countly.shared.consent

        switch row {
        case 0: consent.giveConsent(for: .sessions)
        case 1: consent.giveConsent(for: [.events, .viewTracking])
        case 2: consent.giveAllConsents()
        case 3: consent.cancelConsent(for: .events)
        case 4: consent.cancelAllConsents()
        case 5: print("sessions consent: \(consent.hasConsent(for: .sessions))")
        default: break
        }
    }

    // MARK: - Device ID

    private func runDeviceID(_ row: Int) {
        let deviceID = Countly.shared.deviceID

        switch row {
        case 0:
            print("device ID: \(deviceID.current ?? "none"), type: \(String(describing: deviceID.type)), temporary: \(deviceID.isTemporaryIDMode)")
        // Merges when the current ID was generated by the SDK, and does not when
        // the host application supplied it: a second supplied ID is a new user.
        case 1: deviceID.setID("new-device-id")
        case 2: deviceID.changeWithMerge("merged-device-id")
        case 3: deviceID.changeWithoutMerge("fresh-device-id")
        case 4: deviceID.enableTemporaryIDMode()
        case 5: deviceID.changeWithoutMerge("real-device-id")
        default: break
        }
    }

    // MARK: - Crash Reporting

    private func runCrashReporting(_ row: Int) {
        let crashes = Countly.shared.crashes

        switch row {
        case 0:
            crashes.recordError("HandledError", isFatal: false,
                                stackTrace: Thread.callStackSymbols,
                                segmentation: ["where": "sample app"])
        case 1:
            let exception = NSException(name: .init("MyException"),
                                        reason: "MyReason",
                                        userInfo: ["info": "value"])
            crashes.recordException(exception, isFatal: false, stackTrace: nil, segmentation: nil)
        case 2:
            crashes.recordError("FatalError", isFatal: true, stackTrace: nil, segmentation: nil)
        case 3: crashes.addCrashBreadcrumb("breadcrumb at \(Date())")
        case 4: crashes.clearCrashBreadcrumbs()
        case 5: crashes.setCrashSegmentation(["SomeOtherSDK": "v3.4.5"])

        // The rows below deliberately kill the process. The report is written to
        // the queue and sent on the next launch.
        case 6: NSObject().perform(NSSelectorFromString("nonExistentSelector"))
        case 7:
            let array = [0, 1, 2]
            print(array[5])
        case 8:
            let optional: String? = nil
            print(optional!)
        case 9: assertionFailure("deliberate assertion failure")
        case 10: abort()
        default: break
        }
    }

    // MARK: - Remote Config

    private func runRemoteConfig(_ row: Int) {
        let remoteConfig = Countly.shared.remoteConfig

        switch row {
        case 0:
            remoteConfig.downloadKeys { result, error, fullUpdate, values in
                print("download all: \(result), full: \(fullUpdate), count: \(values.count), error: \(String(describing: error))")
            }
        case 1:
            remoteConfig.downloadSpecificKeys(["welcome_text"]) { result, _, _, values in
                print("download specific: \(result), count: \(values.count)")
            }
        case 2:
            remoteConfig.downloadOmittingKeys(["welcome_text"]) { result, _, _, values in
                print("download omitting: \(result), count: \(values.count)")
            }
        case 3:
            let data = remoteConfig.getValue("welcome_text")
            print("welcome_text: \(String(describing: data.value)), currentUser: \(data.isCurrentUsersData)")
        case 4:
            for (key, data) in remoteConfig.getAllValues() {
                print("  \(key) = \(String(describing: data.value))")
            }
        case 5:
            let callback: RCDownloadCallback = { result, _, _, values in
                print("global callback fired: \(result), count: \(values.count)")
            }
            remoteConfigCallback = callback
            remoteConfig.registerDownloadCallback(callback)
        case 6:
            remoteConfig.removeAllDownloadCallbacks()
            remoteConfigCallback = nil
        case 7: remoteConfig.clearAll()
        default: break
        }
    }

    // MARK: - A/B Testing

    private func runABTesting(_ row: Int) {
        let remoteConfig = Countly.shared.remoteConfig

        switch row {
        // Reading a value is what enrolls this device into the experiment behind it.
        case 0: print("value and enroll: \(String(describing: remoteConfig.getValueAndEnroll("welcome_text").value))")
        case 1: print("all values and enroll: \(remoteConfig.getAllValuesAndEnroll().count)")
        case 2: remoteConfig.enrollIntoABTests(forKeys: ["welcome_text"])
        case 3: remoteConfig.exitABTests(forKeys: ["welcome_text"])
        case 4:
            remoteConfig.testingDownloadVariantInformation { result, error in
                print("variant download: \(result), error: \(String(describing: error))")
            }
        case 5: print("all variants: \(remoteConfig.testingGetAllVariants())")
        case 6: print("variants for welcome_text: \(remoteConfig.testingGetVariants(forKey: "welcome_text"))")
        case 7:
            remoteConfig.testingDownloadExperimentInformation { result, error in
                print("experiment download: \(result), error: \(String(describing: error))")
            }
        case 8:
            for (id, info) in remoteConfig.testingGetAllExperimentInfo() {
                print("  \(id): \(info.experimentName), current variant: \(info.currentVariant)")
            }
        case 9:
            remoteConfig.testingEnrollIntoVariant(key: "welcome_text", variantName: "A") { result, error in
                print("enroll into variant: \(result), error: \(String(describing: error))")
            }
        default: break
        }
    }

    // MARK: - Feedback Widgets

    private func runFeedbackWidgets(_ row: Int) {
        let feedback = Countly.shared.feedback

        switch row {
        case 0:
            feedback.getAvailableFeedbackWidgets { widgets, error in
                guard let widgets else { return print("widget list failed: \(String(describing: error))") }
                for widget in widgets {
                    print("  \(widget.type.wireName): \(widget.name) [\(widget.id)]")
                }
            }
        case 1: feedback.presentNPS { state in print("NPS widget: \(state)") }
        case 2: feedback.presentSurvey { state in print("survey widget: \(state)") }
        case 3: feedback.presentRating { state in print("rating widget: \(state)") }
        case 4:
            feedback.recordRatingWidget(id: "WIDGET_ID",
                                        rating: 4,
                                        email: "john@example.com",
                                        comment: "good",
                                        userCanBeContacted: true)
        default: break
        }
    }

    // MARK: - Content

    private func runContent(_ row: Int) {
        let content = Countly.shared.content

        switch row {
        case 0: content.enterContentZone()
        case 1: content.enterContentZone(tags: ["promo"])
        case 2: content.refreshContentZone()
        case 3: content.changeContent(tags: ["seasonal"])
        // Shows one specific content entry, bypassing the zone and its triggers.
        case 4: content.previewContent("CONTENT_ID")
        case 5: content.exitContentZone()
        default: break
        }
    }

    // MARK: - Performance Monitoring

    private func runPerformance(_ row: Int) {
        let performance = Countly.shared.performance

        switch row {
        case 0:
            let now = Int64(Date().timeIntervalSince1970 * 1000)
            performance.recordNetworkTrace("/api/items",
                                           requestPayloadSize: 128,
                                           responsePayloadSize: 1024,
                                           responseStatusCode: 200,
                                           startTime: now - 500,
                                           endTime: now)
        case 1: performance.startCustomTrace("custom-trace")
        case 2: performance.endCustomTrace("custom-trace")
        case 3: performance.endCustomTrace("custom-trace", metrics: ["steps": 3])
        case 4: performance.cancelCustomTrace("custom-trace")
        case 5: performance.clearAllCustomTraces()
        case 6: performance.appLoadingFinished()
        default: break
        }
    }

    // MARK: - Location

    private func runLocation(_ row: Int) {
        let location = Countly.shared.location

        switch row {
        case 0:
            location.recordLocation(CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917),
                                    city: "Tokyo",
                                    isoCountryCode: "JP",
                                    ipAddress: "128.0.0.1")
        case 1: location.recordLocation(city: "Istanbul", isoCountryCode: "TR")
        case 2: location.recordLocation(CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784))
        case 3: location.recordLocation(ipAddress: "10.0.0.1")
        // Sends an empty location, which stops the server using geo-IP.
        case 4: location.disableLocationInfo()
        default: break
        }
    }

    // MARK: - Attribution

    private func runAttribution(_ row: Int) {
        let attribution = Countly.shared.attribution

        switch row {
        // Direct attribution carries a Countly campaign the user came from. The
        // payload is the JSON a deep link handed the application.
        case 0:
            attribution.recordDirectAttribution(campaignType: "countly",
                                                campaignData: "{\"cid\":\"CAMPAIGN_ID\",\"cuid\":\"CAMPAIGN_USER_ID\"}")
        case 1:
            attribution.recordDirectAttribution(campaignType: "countly",
                                                campaignData: "{\"cid\":\"CAMPAIGN_ID\"}")
        // Indirect attribution carries advertising identifiers the host
        // application obtained itself. The SDK never collects them on its own.
        case 2: attribution.recordIndirectAttribution(["idfa": "ADVERTISING_ID"])
        case 3: attribution.recordIndirectAttribution(["idfa": "ADVERTISING_ID", "idfv": "VENDOR_ID"])
        default: break
        }
    }

    // MARK: - Push Notifications

    private func runPush(_ row: Int) {
        let push = Countly.shared.push

        switch row {
        case 0: push.askForNotificationPermission()
        case 1:
            // Badge, sound and alert.
            push.askForNotificationPermission(options: 1 | 2 | 4) { granted, error in
                print("permission granted: \(granted), error: \(String(describing: error))")
            }
        case 2: push.recordPushNotificationToken()
        case 3: push.clearPushNotificationToken()
        case 4:
            // What the SDK does by itself when a notification is tapped. Index 0
            // is the notification body, 1 and up are its action buttons.
            let userInfo: [AnyHashable: Any] = ["c": ["i": "NOTIFICATION_ID"]]
            push.recordAction(for: userInfo, clickedButtonIndex: 0)
        default: break
        }
    }

    // MARK: - Request Queue

    private func runRequestQueue(_ row: Int) {
        let queue = Countly.shared.requestQueue

        switch row {
        case 0: print("queued requests: \(queue.count)")
        case 1: queue.attemptToSendStoredRequests()
        // Drops everything queued without sending it.
        case 2: queue.flushQueues()
        case 3: queue.replaceAllAppKeysInQueueWithCurrentAppKey()
        case 4: queue.removeDifferentAppKeysFromQueue()
        case 5: Countly.shared.addDirectRequest(["custom_key": "custom_value"])
        case 6: Countly.shared.recordMetrics(["_custom_metric": "custom_value"])
        case 7:
            queue.addQueueFlushRunnable {
                print("the request queue drained with nothing failing")
            }
        case 8: queue.clearQueueFlushRunnables()
        default: break
        }
    }

    // MARK: - Multiple Instances

    private func runMultipleInstances(_ row: Int) {
        let second = Countly.instance(named: secondInstanceName)

        switch row {
        case 0:
            guard !second.isStarted else { return print("the second instance is already running") }
            let config = CountlyConfig()
            config.appKey = "SECOND_APP_KEY"
            config.host = "https://your.server.ly"
            config.enableDebug = true
            // Its own storage namespace, so it cannot see the default instance's
            // device ID, queue or consent state.
            second.start(with: config)
        case 1: second.events.recordEvent("event-on-second-instance")
        case 2: print("instances: \(Countly.listInstances())")
        // Unlike `instance(named:)` this never creates one, so it answers
        // "is this instance already running" without starting anything.
        case 3: print("existing instance: \(Countly.getInstance(named: secondInstanceName) != nil)")
        case 4: second.halt()
        case 5: second.halt(clearStorage: true)
        case 6: Countly.haltAllInstances()
        default: break
        }
    }

    // MARK: - Multi Threading

    private func runMultiThreading(_ row: Int) {
        guard row < queues.count else { return }

        if queues[row] == nil {
            queues[row] = DispatchQueue(label: "sample.thread.\(row)")
        }

        // Every public call is safe from any thread; this is here to prove it.
        queues[row]?.async {
            for index in 0..<10 {
                Countly.shared.events.recordEvent("multi-threading-event",
                                                  segmentation: ["thread": "\(row)", "index": "\(index)"])
            }
        }
    }

    // MARK: - Others

    private func runOthers(_ row: Int) {
        switch row {
        case 0: Countly.shared.setNewHost("https://your.other.server.ly")
        case 1: Countly.shared.setNewAppKey("YOUR_OTHER_APP_KEY")
        case 2: Countly.shared.addCustomNetworkRequestHeaders(["X-My-Custom-Field": "my_custom_value"])
        case 3:
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 15
            configuration.allowsCellularAccess = false
            Countly.shared.setNewURLSessionConfiguration(configuration)
        // Stops the instance but leaves what is on disk alone.
        case 4: Countly.shared.halt()
        // Stops it and erases everything it stored, for a data deletion request.
        case 5: Countly.shared.halt(clearStorage: true)
        default: break
        }
    }
}
