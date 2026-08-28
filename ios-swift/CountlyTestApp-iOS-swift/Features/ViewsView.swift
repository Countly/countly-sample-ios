// ViewsView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct ViewsView: View {
    private var views: ViewsAPI { Countly.shared.views }

    /// Kept so pause, resume and stop can act on the view that was started.
    @State private var startedViewID: String?

    var body: some View {
        Form {
            Section("Start") {
                ActionButton("Start View") {
                    startedViewID = views.startView("View A", segmentation: ["origin": "manual"])
                    AppLog.shared.log("started view id: \(startedViewID ?? "nil")")
                }
                ActionButton("Start Auto Stopped View") {
                    startedViewID = views.startAutoStoppedView("Auto Stopped View")
                }
            }

            Section("Stop") {
                ActionButton("Stop View by Name") { views.stopView(name: "View A", segmentation: ["reason": "navigated"]) }
                ActionButton("Stop View by ID") {
                    guard let id = startedViewID else { return AppLog.shared.log("no view started yet") }
                    views.stopView(id: id)
                }
                ActionButton("Stop All Views") { views.stopAllViews(segmentation: ["bulk": "yes"]) }
                ActionButton("Stop a View that was never started") { views.stopView(name: "Missing View") }
            }

            Section("Pause & resume") {
                ActionButton("Pause Current View") {
                    guard let id = startedViewID else { return AppLog.shared.log("no view started yet") }
                    views.pauseView(id: id)
                }
                ActionButton("Resume Current View") {
                    guard let id = startedViewID else { return AppLog.shared.log("no view started yet") }
                    views.resumeView(id: id)
                }
            }

            Section("Segmentation") {
                ActionButton("Set Global View Segmentation") { views.setGlobalViewSegmentation(["tier": "gold"]) }
                ActionButton("Update Global View Segmentation") { views.updateGlobalViewSegmentation(["tier": "platinum", "extra": "added"]) }
                ActionButton("Add Segmentation to View by Name") { views.addSegmentation(toViewWithName: "View A", segmentation: ["late": "addition"]) }
                ActionButton("Add Segmentation to View by ID") {
                    guard let id = startedViewID else { return AppLog.shared.log("no view started yet") }
                    views.addSegmentation(toViewWithID: id, segmentation: ["late": "addition"])
                }
            }

            Section {
                ActionButton("Add Auto View Tracking Exclusion") {
                    views.addAutoViewTrackingExclusionList(["TestViewControllerModal"])
                }
                ActionButton("Present a Modal View Controller") {
                    let controller = TestViewControllerModal()
                    controller.title = "MyModalViewTitle"
                    UIKitSupport.present(controller)
                }
                ActionButton("Present a Pushed View Controller") {
                    let controller = TestViewControllerPushPop()
                    controller.title = "MyPushedViewTitle"
                    UIKitSupport.present(UINavigationController(rootViewController: controller))
                }
            } header: {
                Text("Automatic view tracking")
            } footer: {
                Text("Set enableAutomaticViewTracking in the configuration and presenting these reports a view named after the controller's title. An automatically tracked view is auto stopped, so each one reports how long it was on screen.")
            }
        }
    }
}
