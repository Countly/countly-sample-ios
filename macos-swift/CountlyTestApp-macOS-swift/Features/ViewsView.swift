// ViewsView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// Manual view tracking.
///
/// There is no automatic tracking section here: the swizzle that reports a view
/// for every appeared screen is `AutoViewTracker`, guarded to `os(iOS) || os(tvOS)`,
/// and `ViewsModule.handleAutoTrackedViewController` behind the same guard. On
/// macOS a view is only ever reported because the application asked for it.
struct ViewsView: View {
    private var views: ViewsAPI { AppContext.active.views }

    /// Kept so pause, resume and stop can act on the view that was started.
    @State private var startedViewID: String?

    var body: some View {
        FeatureList {
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

            Section {
                ActionButton("Set Global View Segmentation") { views.setGlobalViewSegmentation(["tier": "gold"]) }
                ActionButton("Update Global View Segmentation") { views.updateGlobalViewSegmentation(["tier": "platinum", "extra": "added"]) }
                ActionButton("Add Segmentation to View by Name") { views.addSegmentation(toViewWithName: "View A", segmentation: ["late": "addition"]) }
                ActionButton("Add Segmentation to View by ID") {
                    guard let id = startedViewID else { return AppLog.shared.log("no view started yet") }
                    views.addSegmentation(toViewWithID: id, segmentation: ["late": "addition"])
                }
            } header: {
                Text("Segmentation")
            } footer: {
                FootnoteText("Global segmentation is merged into every view event. Segmentation added to an open view is reported when that view stops.")
            }

            Section {
                FootnoteText("Automatic view tracking is iOS and tvOS only: it is driven by a UIViewController swizzle. On macOS every view is started and stopped by the application, which is what the sections above do.")
            } header: {
                Text("Not on macOS")
            }
        }
    }
}
