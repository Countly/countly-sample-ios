// FeedbackView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct FeedbackView: View {
    private var feedback: FeedbackAPI { Countly.shared.feedback }

    var body: some View {
        Form {
            Section("Available widgets") {
                ActionButton("Get Available Feedback Widgets") {
                    feedback.getAvailableFeedbackWidgets { widgets, error in
                        guard let widgets else {
                            return AppLog.shared.log("widget list failed: \(error?.localizedDescription ?? "unknown")")
                        }
                        AppLog.shared.log(widgets.isEmpty
                            ? "no widgets configured for this application"
                            : widgets.map { "\($0.type.wireName): \($0.name)" }.joined(separator: "; "))
                    }
                }
            }

            Section {
                ActionButton("Present NPS") { feedback.presentNPS { AppLog.shared.log("NPS widget: \($0)") } }
                ActionButton("Present Survey") { feedback.presentSurvey { AppLog.shared.log("survey widget: \($0)") } }
                ActionButton("Present Rating") { feedback.presentRating { AppLog.shared.log("rating widget: \($0)") } }
            } header: {
                Text("Present the first of a kind")
            } footer: {
                Text("With no name, ID or tag the SDK presents the first widget of that type the server offers.")
            }

            Section("Present a specific widget") {
                ActionButton("Present NPS by Name, ID or Tag") { feedback.presentNPS("WIDGET_NAME_ID_OR_TAG") { AppLog.shared.log("NPS: \($0)") } }
                ActionButton("Present Survey by Name, ID or Tag") { feedback.presentSurvey("WIDGET_NAME_ID_OR_TAG") { AppLog.shared.log("survey: \($0)") } }
                ActionButton("Present Rating by Name, ID or Tag") { feedback.presentRating("WIDGET_NAME_ID_OR_TAG") { AppLog.shared.log("rating: \($0)") } }
            }

            Section {
                ActionButton("Record a Rating Widget Result Manually") {
                    feedback.recordRatingWidget(id: "WIDGET_ID", rating: 4,
                                                email: "john@example.com",
                                                comment: "good",
                                                userCanBeContacted: true)
                }
            } header: {
                Text("Manual")
            } footer: {
                Text("For a rating collected by the host application's own interface rather than by a Countly widget.")
            }
        }
    }
}
