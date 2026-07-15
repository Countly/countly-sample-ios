// FeedbackView.swift
import SwiftUI
import Countly

struct FeedbackView: View {
    private var f: CountlyFeedbacks { Countly.sharedInstance().feedback() }
    @State private var widgets: [CountlyFeedbackWidget] = []
    var body: some View {
        Form {
            Section("Present (current)") {
                ActionButton("Present NPS") { f.presentNPS() }
                ActionButton("Present Survey") { f.presentSurvey() }
                ActionButton("Present Rating") { f.presentRating() }
                ActionButton("Present NPS by name/tag") { f.presentNPS("nps-tag") }
            }
            Section("Widgets (current)") {
                ActionButton("Get Available Feedback Widgets") {
                    f.getAvailableFeedbackWidgets { list, error in
                        widgets = list ?? []
                        AppLog.shared.log(error == nil ? "Widgets: \(widgets.count)" : "Error: \(error!.localizedDescription)")
                    }
                }
                ActionButton("Present first fetched widget") { widgets.first?.present() }
                ActionButton("Get first widget data") {
                    widgets.first?.getData { data, error in
                        AppLog.shared.log(error == nil ? "Widget data keys: \(data?.keys.map { "\($0)" } ?? [])" : "Error: \(error!.localizedDescription)")
                    }
                }
                ActionButton("Record result (dismiss) for first widget") { widgets.first?.recordResult(nil) }
                ActionButton("Inspect first widget") {
                    if let w = widgets.first { AppLog.shared.log("id=\(w.id) name=\(w.name) type=\(w.type) tags=\(w.tags)") }
                    else { AppLog.shared.log("No widgets fetched yet") }
                }
            }
            Section {
                ActionButton("Present Rating Widget by ID") {
                    Countly.sharedInstance().presentRatingWidget(withID: "YOUR_WIDGET_ID") { error in
                        AppLog.shared.log("presentRatingWidget \(error?.localizedDescription ?? "ok")")
                    }
                }
                ActionButton("getFeedbackWidgets (deprecated)") {
                    Countly.sharedInstance().getFeedbackWidgets { list, error in
                        AppLog.shared.log(error == nil ? "Legacy widgets: \(list?.count ?? 0)" : "Error: \(error!.localizedDescription)")
                    }
                }
            } header: { Text("Legacy (deprecated)") }
              footer: { Text("Prefer feedback().presentNPS/Survey/Rating and getAvailableFeedbackWidgets.") }
        }
    }
}
