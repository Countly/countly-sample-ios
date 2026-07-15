// ViewsView.swift
import SwiftUI
import Countly

struct ViewsView: View {
    private var v: CountlyViewTracking { Countly.sharedInstance().views() }
    @State private var lastViewID: String = ""
    var body: some View {
        Form {
            Section("Start / Stop (current)") {
                ActionButton("Start View 'Dashboard'") { lastViewID = v.startView("Dashboard") }
                ActionButton("Start View + segmentation") { lastViewID = v.startView("Dashboard", segmentation: ["k": "v"]) }
                ActionButton("Start Auto-Stopped View") { lastViewID = v.startAutoStoppedView("AutoStopped") }
                ActionButton("Start Auto-Stopped View + segmentation") { lastViewID = v.startAutoStoppedView("AutoStopped", segmentation: ["k": "v"]) }
                ActionButton("Stop View by name 'Dashboard'") { v.stopView(withName: "Dashboard") }
                ActionButton("Stop View by name + segmentation") { v.stopView(withName: "Dashboard", segmentation: ["k": "v"]) }
                ActionButton("Stop last view by ID") { v.stopView(withID: lastViewID) }
                ActionButton("Stop last view by ID + segmentation") { v.stopView(withID: lastViewID, segmentation: ["k": "v"]) }
                ActionButton("Pause last view by ID") { v.pauseView(withID: lastViewID) }
                ActionButton("Resume last view by ID") { v.resumeView(withID: lastViewID) }
                ActionButton("Stop All Views") { v.stopAllViews(["k": "v"]) }
            }
            Section("Segmentation (current)") {
                ActionButton("Set Global View Segmentation") { v.setGlobalViewSegmentation(["app": "sample"]) }
                ActionButton("Update Global View Segmentation") { v.updateGlobalViewSegmentation(["extra": "1"]) }
                ActionButton("Add Segmentation to last view (by ID)") { v.addSegmentationToView(withID: lastViewID, segmentation: ["added": "byID"]) }
                ActionButton("Add Segmentation to view (by name)") { v.addSegmentationToView(withName: "Dashboard", segmentation: ["added": "byName"]) }
            }
            Section("Auto view tracking (present real VCs)") {
                ActionButton("Present Modal View Controller") { presentModal() }
                ActionButton("Push / Pop with Navigation Controller") { presentPushPop() }
            }
            Section {
                ActionButton("Record View A (deprecated)") { Countly.sharedInstance().recordView("View A") }
                ActionButton("Record View + segmentation (deprecated)") { Countly.sharedInstance().recordView("View B", segmentation: ["k": "v"]) }
                ActionButton("Report View Manually (deprecated)") { Countly.sharedInstance().recordView("ManualViewReportExample") }
                ActionButton("Turn OFF AutoViewTracking (deprecated)") { Countly.sharedInstance().isAutoViewTrackingActive = false }
                ActionButton("Turn ON AutoViewTracking (deprecated)") { Countly.sharedInstance().isAutoViewTrackingActive = true }
                ActionButton("Add AutoViewTracking Exception (deprecated)") { Countly.sharedInstance().addException(forAutoViewTracking: "MyViewControllerTitle") }
                ActionButton("Remove AutoViewTracking Exception (deprecated)") { Countly.sharedInstance().removeException(forAutoViewTracking: "MyViewControllerTitle") }
            } header: { Text("Legacy (deprecated)") }
              footer: { Text("Prefer views.startView/startAutoStoppedView and setGlobalViewSegmentation.") }
        }
    }
    private func presentModal() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TestViewControllerModal")
        vc.title = "MyViewControllerTitle"
        UIKitSupport.present(vc)
    }
    private func presentPushPop() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TestViewControllerPushPop")
        let nc = UINavigationController(rootViewController: vc)
        UIKitSupport.present(nc)
    }
}
